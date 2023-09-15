import 'modular_localization_entries.dart';

class ModularLocalizationEntriesEnUs extends ModularLocalizationEntries {
  const ModularLocalizationEntriesEnUs();

  @override
  /// **"Hi, would you care for a cup of %s?"**
  String entry0([List<String> args = const []]) => replaceArguments('Hi, would you care for a cup of %s?', args);

  @override
  /// **"coffee"**
  String get entry1 => 'coffee';

  @override
  /// **"tea"**
  String get entry2 => 'tea';
}
