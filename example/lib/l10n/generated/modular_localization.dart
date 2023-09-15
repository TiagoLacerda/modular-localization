import 'modular_localization_delegate.dart';
import 'modular_localization_entries.dart';
import 'modular_localization_entries_en_us.dart';

abstract class ModularLocalization {
  const ModularLocalization();

  static ModularLocalizationEntries entries = const ModularLocalizationEntriesEnUs();

  /// modular_localization's `LocalizationsDelegate`.
  static const delegate = ModularLocalizationDelegate();

  /// Localized resources.
  static const ModularLocalizationInternalClass0 localizations =
      ModularLocalizationInternalClass0();
}

class ModularLocalizationInternalClass0 implements ModularLocalization {
  const ModularLocalizationInternalClass0();

  /// `en-US`: **"Hi, would you care for a cup of %s?"**
  ///
  /// `pt-BR`: **"Olá, gostaria de uma xícara de %s?"**
  ///
  String greeting([List<String> args = const []]) => ModularLocalization.entries.entry0(args);

  /// **.coffee**
  ///
  /// `en-US`: **"coffee"**
  ///
  /// `pt-BR`: **"café"**
  ///
  /// **.tea**
  ///
  /// `en-US`: **"tea"**
  ///
  /// `pt-BR`: **"chá"**
  ///
  ModularLocalizationInternalClass1 get drinks => const ModularLocalizationInternalClass1();
}

class ModularLocalizationInternalClass1 implements ModularLocalization {
  const ModularLocalizationInternalClass1();

  /// `en-US`: **"coffee"**
  ///
  /// `pt-BR`: **"café"**
  ///
  String get coffee => ModularLocalization.entries.entry1;

  /// `en-US`: **"tea"**
  ///
  /// `pt-BR`: **"chá"**
  ///
  String get tea => ModularLocalization.entries.entry2;

}


