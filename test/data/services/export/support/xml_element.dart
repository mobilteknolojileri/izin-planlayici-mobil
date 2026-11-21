/// A parsed XML element, enough to inspect the parts the exports write.
class XmlElement {
  /// Creates an element named [name].
  new(this.name, this.attributes);

  /// Qualified tag name, e.g. `c` or `xml:space`.
  final String name;

  /// Attribute values, already unescaped.
  final Map<String, String> attributes;

  /// Child elements in document order.
  final List<XmlElement> children = [];

  final StringBuffer _text = StringBuffer();

  /// Direct text content, unescaped.
  String get text => _text.toString();

  /// All elements below this one named [tag], depth first.
  Iterable<XmlElement> descendants(String tag) sync* {
    for (final child in children) {
      if (child.name == tag) yield child;
      yield* child.descendants(tag);
    }
  }

  /// Parses [source] and throws [FormatException] unless it is well-formed
  /// XML 1.0 without a DTD.
  ///
  /// Checks the character set, tag nesting, a single root, quoted and unique
  /// attributes and every entity or character reference.
  static XmlElement parse(String source) => _XmlParser(source).parse();
}

class _XmlParser {
  new(this.s);

  final String s;
  int i = 0;

  static final _nameStart = RegExp('[A-Za-z_:]');
  static final _nameChar = RegExp(r'[A-Za-z0-9_:.\-]');
  static final _space = RegExp(r'[ \t\r\n]');

  Never _fail(String message) =>
      throw FormatException('XML: $message at $i', s, i);

  XmlElement parse() {
    _checkCharacters();
    if (s.startsWith('<?xml')) {
      final end = s.indexOf('?>');
      if (end < 0) _fail('unclosed declaration');
      i = end + 2;
    }
    final stack = <XmlElement>[];
    XmlElement? root;
    while (i < s.length) {
      if (s[i] != '<') {
        var end = s.indexOf('<', i);
        if (end < 0) end = s.length;
        final raw = s.substring(i, end);
        if (raw.contains(']]>')) _fail('"]]>" in text');
        if (stack.isEmpty) {
          if (raw.trim().isNotEmpty) _fail('text outside the root');
        } else {
          stack.last._text.write(_unescape(raw));
        }
        i = end;
        continue;
      }
      if (s.startsWith('<!--', i)) {
        final end = s.indexOf('-->', i + 4);
        if (end < 0) _fail('unclosed comment');
        i = end + 3;
        continue;
      }
      if (s.startsWith('<![CDATA[', i)) {
        final end = s.indexOf(']]>', i);
        if (end < 0 || stack.isEmpty) _fail('bad CDATA');
        stack.last._text.write(s.substring(i + 9, end));
        i = end + 3;
        continue;
      }
      if (s.startsWith('<?', i)) {
        final end = s.indexOf('?>', i);
        if (end < 0) _fail('unclosed processing instruction');
        i = end + 2;
        continue;
      }
      if (s.startsWith('<!', i)) _fail('DTD is not allowed');
      if (s.startsWith('</', i)) {
        i += 2;
        final name = _name();
        _skipSpace();
        if (i >= s.length || s[i] != '>') _fail('bad end tag');
        i++;
        if (stack.isEmpty || stack.last.name != name) {
          _fail('end tag </$name> does not match');
        }
        stack.removeLast();
        continue;
      }

      i++;
      final element = XmlElement(_name(), {});
      var selfClosing = false;
      while (true) {
        final hadSpace = _skipSpace();
        if (i >= s.length) _fail('unclosed start tag');
        if (s.startsWith('/>', i)) {
          selfClosing = true;
          i += 2;
          break;
        }
        if (s[i] == '>') {
          i++;
          break;
        }
        if (!hadSpace) _fail('no space before attribute');
        final attribute = _name();
        _skipSpace();
        if (i >= s.length || s[i] != '=') _fail('attribute without "="');
        i++;
        _skipSpace();
        if (i >= s.length) _fail('unclosed start tag');
        final quote = s[i];
        if (quote != '"' && quote != "'") _fail('unquoted attribute');
        final end = s.indexOf(quote, i + 1);
        if (end < 0) _fail('unclosed attribute');
        final raw = s.substring(i + 1, end);
        if (raw.contains('<')) _fail('"<" in attribute');
        if (element.attributes.containsKey(attribute)) {
          _fail('duplicate attribute $attribute');
        }
        element.attributes[attribute] = _unescape(raw);
        i = end + 1;
      }
      if (stack.isEmpty) {
        if (root != null) _fail('second root element');
        root = element;
      } else {
        stack.last.children.add(element);
      }
      if (!selfClosing) stack.add(element);
    }
    if (stack.isNotEmpty) _fail('unclosed <${stack.last.name}>');
    return root ?? _fail('no root element');
  }

  String _name() {
    final start = i;
    if (i >= s.length || !_nameStart.hasMatch(s[i])) _fail('bad name');
    while (i < s.length && _nameChar.hasMatch(s[i])) {
      i++;
    }
    return s.substring(start, i);
  }

  bool _skipSpace() {
    final start = i;
    while (i < s.length && _space.hasMatch(s[i])) {
      i++;
    }
    return i > start;
  }

  void _checkCharacters() {
    for (final rune in s.runes) {
      final ok =
          rune == 0x9 ||
          rune == 0xA ||
          rune == 0xD ||
          (rune >= 0x20 && rune <= 0xD7FF) ||
          (rune >= 0xE000 && rune <= 0xFFFD) ||
          (rune >= 0x10000 && rune <= 0x10FFFF);
      if (!ok) _fail('invalid character U+${rune.toRadixString(16)}');
    }
  }

  String _unescape(String raw) {
    final out = StringBuffer();
    var at = 0;
    while (at < raw.length) {
      final amp = raw.indexOf('&', at);
      if (amp < 0) {
        out.write(raw.substring(at));
        break;
      }
      out.write(raw.substring(at, amp));
      final semi = raw.indexOf(';', amp);
      if (semi < 0) _fail('bare "&"');
      final entity = raw.substring(amp + 1, semi);
      out.write(switch (entity) {
        'amp' => '&',
        'lt' => '<',
        'gt' => '>',
        'quot' => '"',
        'apos' => "'",
        _ when RegExp(r'^#x[0-9A-Fa-f]+$').hasMatch(entity) =>
          String.fromCharCode(int.parse(entity.substring(2), radix: 16)),
        _ when RegExp(r'^#[0-9]+$').hasMatch(entity) => String.fromCharCode(
          int.parse(entity.substring(1)),
        ),
        _ => _fail('unknown entity &$entity;'),
      });
      at = semi + 1;
    }
    return out.toString();
  }
}
