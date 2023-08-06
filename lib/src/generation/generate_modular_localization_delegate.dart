import '../metadata.dart';

String generateModularLocalizationDelegate(Metadata metadata) {
  // ENTRIES FILE IMPORTS
  var imports = metadata.supportedLocales.map(
    (locale) =>
        "import 'modular_localization_entries_${locale.toSnakeCase()}.dart';",
  );

  // LOAD METHOD'S SWITCH CASES
  var cases = metadata.supportedLocales.map(
    (locale) =>
        "      case '$locale': return const ModularLocalizationEntries${locale.toPascalCase()}();",
  );

  // SUPPORTED LOCALES
  var locales =
      metadata.supportedLocales.map((locale) => "'$locale'").join(', ');

  return """
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'modular_localization_entries.dart';
${imports.join("\n")}

class ModularLocalizationDelegate extends LocalizationsDelegate<ModularLocalizationEntries> {
  ModularLocalizationDelegate();

  ModularLocalizationEntries fallback = ModularLocalizationEntries${metadata.supportedLocales.first.toPascalCase()}();

  @override
  Future<ModularLocalizationEntries> load(Locale locale) {
    var entries = _load(locale);
    fallback = entries;
    return SynchronousFuture<ModularLocalizationEntries>(entries);  
  }

  ModularLocalizationEntries _load(Locale locale)
  {
    switch (locale.toLanguageTag()) {
${cases.join("\n")}
    }

    throw FlutterError(
      'ModularLocalization.delegate failed to load unsupported locale "\$locale"',
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>[$locales].contains(locale.toLanguageTag());

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
""";
}
