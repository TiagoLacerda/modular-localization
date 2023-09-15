import '../metadata.dart';

String generateModularLocalizationDelegate(Metadata metadata) {
  // ENTRIES FILE IMPORTS
  var imports = metadata.supportedLocales.map((locale) {
    return 'import \'modular_localization_entries_${locale.toSnakeCase()}.dart\';';
  }).join('\n');

  // LOAD METHOD'S SWITCH CASES
  var cases = metadata.supportedLocales.map((locale) {
    return """
      case '$locale':
        entries = const ModularLocalizationEntries${locale.toPascalCase()}();
        break;""";
  }).join('\n');

  // SUPPORTED LOCALES
  var supportedLocales = metadata.supportedLocales.map((locale) {
    var string =
        '    Locale.fromSubtags(languageCode: \'${locale.languageCode}\'';

    if (locale.scriptCode != null) {
      string += ', scriptCode: \'${locale.scriptCode}\'';
    }

    if (locale.countryCode != null) {
      string += ', countryCode: \'${locale.countryCode}\'';
    }

    string += '),';

    return string;
  }).join('\n');

  return """
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'modular_localization.dart';
import 'modular_localization_entries.dart';
$imports

class ModularLocalizationDelegate extends LocalizationsDelegate<ModularLocalizationEntries> {
  const ModularLocalizationDelegate();

  final supportedLocales = const <Locale>[
$supportedLocales
  ];

  @override
  Future<ModularLocalizationEntries> load(Locale locale) {
    ModularLocalizationEntries? entries;

    var resolved = basicLocaleListResolution([locale], supportedLocales);

    switch (resolved.toLanguageTag()) {
$cases
    }

    if (entries == null) {
      throw FlutterError(
        'ModularLocalization.delegate failed to load unsupported locale "\$locale"',
      );
    }

    ModularLocalization.entries = entries;
    return SynchronousFuture<ModularLocalizationEntries>(entries);
  }

  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
""";
}
