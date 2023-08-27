import 'dart:convert';
import 'dart:io';

import 'package:modular_localization/src/generation/generate_modular_localization.dart';
import 'package:modular_localization/src/generation/generate_modular_localization_delegate.dart';
import 'package:modular_localization/src/generation/generate_modular_localization_entries.dart';
import 'package:modular_localization/src/locale.dart';
import 'package:modular_localization/src/metadata.dart';

void main(List<String> args) {
  // DEFINE DIRECTORIES WHERE FILES WILL BE LOADED FROM AND SAVED TO
  var source = args.isNotEmpty ? args[0] : 'lib/l10n';
  var target = args.length > 1 ? args[1] : 'lib/l10n/generated';

  // INITIALIZE METADATA
  var metadata = Metadata(
    supportedLocales: [],
    group: Group(
      label: '',
      values: [],
      groups: [],
    ),
  );

  // LOAD FILES
  var files = Directory(source).listSync().whereType<File>();

  // MERGE EACH l10n FILE
  for (var file in files) {
    var locale = Locale.parse(
      file.uri.pathSegments.last.replaceAll('.json', ''),
    );

    var json = jsonDecode(file.readAsStringSync());

    metadata.supportedLocales.add(locale);
    metadata.merge(json, locale);
  }

  if (metadata.supportedLocales.isEmpty) {
    throw Exception('Your application must support at least one Locale!');
  }

  String code;
  String path;

  // GENERATE ModularLocalizationEntries CLASS
  code = generateModularLocalizationEntries(metadata);
  path = '$target/modular_localization_entries.dart';
  File(path).createSync(recursive: true);
  File(path).openWrite().write(code);

  // GENERATE ModularLocalizationEntries CLASS FOR EACH LOCALE
  for (var locale in metadata.supportedLocales) {
    code = generateModularLocalizationEntriesForLocale(metadata, locale);
    path = '$target/modular_localization_entries_${locale.toSnakeCase()}.dart';
    File(path).createSync(recursive: true);
    File(path).openWrite().write(code);
  }

  // GENERATE ModularLocalizationDelegate CLASS
  code = generateModularLocalizationDelegate(metadata);
  path = '$target/modular_localization_delegate.dart';
  File(path).createSync(recursive: true);
  File(path).openWrite().write(code);

  // GENERATE ModularLocalization CLASS
  code = generateModularLocalization(metadata);
  path = '$target/modular_localization.dart';
  File(path).createSync(recursive: true);
  File(path).openWrite().write(code);
}
