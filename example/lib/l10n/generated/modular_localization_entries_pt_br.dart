import 'modular_localization_entries.dart';

class ModularLocalizationEntriesPtBr extends ModularLocalizationEntries {
  const ModularLocalizationEntriesPtBr();

  @override
  /// **"Olá, gostaria de uma xícara de %s?"**
  String entry0([List<String> args = const []]) => replaceArguments('Olá, gostaria de uma xícara de %s?', args);

  @override
  /// **"café"**
  String get entry1 => 'café';

  @override
  /// **"chá"**
  String get entry2 => 'chá';
}
