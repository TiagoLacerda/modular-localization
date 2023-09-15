import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'modular_localization.dart';
import 'modular_localization_entries.dart';
import 'modular_localization_entries_en_us.dart';
import 'modular_localization_entries_pt_br.dart';

class ModularLocalizationDelegate extends LocalizationsDelegate<ModularLocalizationEntries> {
  const ModularLocalizationDelegate();

  final supportedLocales = const <Locale>[
    Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
    Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
  ];

  @override
  Future<ModularLocalizationEntries> load(Locale locale) {
    ModularLocalizationEntries? entries;

    var resolved = basicLocaleListResolution([locale], supportedLocales);

    switch (resolved.toLanguageTag()) {
      case 'en-US':
        entries = const ModularLocalizationEntriesEnUs();
        break;
      case 'pt-BR':
        entries = const ModularLocalizationEntriesPtBr();
        break;
    }

    if (entries == null) {
      throw FlutterError(
        'ModularLocalization.delegate failed to load unsupported locale "$locale"',
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
