import 'dart:convert';
import 'dart:typed_data';

/// Copy of [bytes] with the first byte of the UTF-8 [ascii] text after its
/// opening quote replaced by [replacement], e.g. a key `"texts"` becomes
/// `"Texts"`. The JSON stays valid, only one byte changes.
Uint8List withChangedByte(Uint8List bytes, String ascii, String replacement) {
  final needle = utf8.encode(ascii);
  for (var i = 0; i + needle.length <= bytes.length; i++) {
    var match = true;
    for (var j = 0; j < needle.length && match; j++) {
      match = bytes[i + j] == needle[j];
    }
    if (match) {
      return Uint8List.fromList(bytes)..[i + 1] = replacement.codeUnitAt(0);
    }
  }
  throw ArgumentError.value(ascii, 'ascii', 'not found');
}
