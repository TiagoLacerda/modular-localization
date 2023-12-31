import '../metadata.dart';

String generateModularLocalization(Metadata metadata) {
  var internalClasses = generateInternalClasses(metadata);

  return """
import 'modular_localization_delegate.dart';
import 'modular_localization_entries.dart';
import 'modular_localization_entries_${metadata.supportedLocales.first.toSnakeCase()}.dart';

abstract class ModularLocalization {
  const ModularLocalization();

  static ModularLocalizationEntries entries = const ModularLocalizationEntries${metadata.supportedLocales.first.toPascalCase()}();

  /// modular_localization's `LocalizationsDelegate`.
  static const delegate = ModularLocalizationDelegate();

  /// Localized resources.
  static const ModularLocalizationInternalClass0 localizations =
      ModularLocalizationInternalClass0();
}

$internalClasses
""";
}

String generateInternalClasses(Metadata metadata) {
  var buffer = StringBuffer();
  _generateInternalClasses(metadata.group, buffer);
  return buffer.toString();
}

void _generateInternalClasses(
  Group group,
  StringBuffer buffer, [
  int groupIndex = 0,
  int valueIndex = 0,
]) {
  // ADD CLASS DEFINITION
  var className = 'ModularLocalizationInternalClass$groupIndex';

  buffer.writeln('class $className implements ModularLocalization {');
  buffer.writeln('  const $className();');
  buffer.writeln('');

  // STRING METHOD/GETTERS
  for (var value in group.values) {
    addValue(value, valueIndex, buffer);
    valueIndex++;
    buffer.writeln('');
  }

  var innerGroupIndex = groupIndex + 1;

  // CLASS GETTERS
  for (var group in group.groups) {
    addGroup(group, innerGroupIndex, buffer);
    innerGroupIndex += group.nestedGroupCount + 1;
  }

  buffer.writeln('}');
  buffer.writeln('');

  for (var group in group.groups) {
    _generateInternalClasses(
      group,
      buffer,
      groupIndex + 1,
      valueIndex,
    );

    groupIndex += group.nestedGroupCount + 1;
    valueIndex += group.nestedValueCount;
  }
}

void addGroup(Group group, int groupIndex, StringBuffer buffer) {
  // FIELD DOCUMENTATION
  for (var value in group.values) {
    buffer.writeln('  /// **.${value.label}**');
    buffer.writeln('  ///');

    for (var locale in value.entries.keys) {
      var entry = value.entries[locale]!.replaceAll('\n', '\\n');

      buffer.writeln('  /// `$locale`: **"$entry"**');
      buffer.writeln('  ///');
    }
  }

  for (var group in group.groups) {
    buffer.writeln('  /// **.${group.label}**: `...`');
    buffer.writeln('  ///');
  }

  // METHOD
  buffer.writeln(
    '  ModularLocalizationInternalClass$groupIndex get ${group.label} => const ModularLocalizationInternalClass$groupIndex();',
  );
}

void addValue(Value value, int index, StringBuffer buffer) {
  // FIELD DOCUMENTATION
  for (var locale in value.entries.keys) {
    var entry = value.entries[locale]!.replaceAll('\n', '\\n');

    buffer.writeln('  /// `$locale`: **"$entry"**');
    buffer.writeln('  ///');
  }

  // GETTER / METHOD
  var field = value.immutable
      ? '  String get ${value.label} => ModularLocalization.entries.entry$index;'
      : '  String ${value.label}([List<String> args = const []]) => ModularLocalization.entries.entry$index(args);';

  buffer.writeln(field);
}
