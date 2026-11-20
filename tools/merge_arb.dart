// Merges lib/l10n/parts/*.arb into lib/l10n/app_tr.arb and runs gen-l10n.
//
// Each feature owns one part file, so parallel agents never edit the same
// file. Keys must start with the part's name in lowerCamelCase
// (leave_form.arb -> leaveForm...), except common.arb. The output is written
// atomically and is the same no matter how often or in which order the
// script runs.
//
// Usage: dart run tools/merge_arb.dart [--no-gen]
import 'dart:convert';
import 'dart:io';

const _partsDir = 'lib/l10n/parts';
const _output = 'lib/l10n/app_tr.arb';

Future<void> main(List<String> args) async {
  final parts =
      Directory(_partsDir)
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.arb'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final merged = <String, Object?>{'@@locale': 'tr'};
  final owners = <String, String>{};
  final errors = <String>[];

  for (final part in parts) {
    final name = part.uri.pathSegments.last;
    final prefix = _camelCase(name.replaceAll('.arb', ''));
    final content = jsonDecode(await part.readAsString());
    if (content is! Map<String, dynamic>) {
      errors.add('$name: not a JSON object');
      continue;
    }
    for (final MapEntry(:key, :value) in content.entries) {
      if (key.startsWith('@@')) continue;
      final messageKey = key.startsWith('@') ? key.substring(1) : key;
      if (name != 'common.arb' && !messageKey.startsWith(prefix)) {
        errors.add('$name: key "$key" must start with "$prefix"');
      }
      final owner = owners[key];
      if (owner != null) {
        errors.add('$name: key "$key" already defined in $owner');
      }
      owners[key] = name;
      merged[key] = value;
    }
  }

  if (errors.isNotEmpty) {
    errors.forEach(stderr.writeln);
    exitCode = 1;
    return;
  }

  final output = File(_output);
  final temp = File('$_output.$pid.tmp');
  await temp.writeAsString(
    '${const JsonEncoder.withIndent('  ').convert(merged)}\n',
  );
  await temp.rename(output.path);
  stdout.writeln('${parts.length} parts merged into $_output');

  if (args.contains('--no-gen')) return;
  final result = await Process.run('flutter', ['gen-l10n'], runInShell: true);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  exitCode = result.exitCode;
}

String _camelCase(String snake) {
  final words = snake.split('_');
  return words.first +
      words.skip(1).map((w) => w[0].toUpperCase() + w.substring(1)).join();
}
