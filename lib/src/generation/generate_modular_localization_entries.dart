import '../locale.dart';
import '../metadata.dart';

/// Generate abstract class extended by each Locale's class.
String generateModularLocalizationEntries(
  Metadata metadata,
) {
  var values = metadata.unnestedValues;

  var fields = <String>[];

  for (int i = 0; i < values.length; i++) {
    var value = values[i];

    // FIELD DOCUMENTATION
    var docstring = value.entries.keys
        .map((e) =>
            '  /// `$e`: **"${value.entries[e]!.replaceAll('\n', '\\n')}"**\n')
        .toList()
        .join('  ///\n');

    // GETTER / METHOD
    var field = value.immutable
        ? '  String get entry$i;'
        : '  String entry$i([List<String> args = const []]);';

    fields.add(docstring + field);
  }

  return """
import 'dart:math';

abstract class ModularLocalizationEntries {
  const ModularLocalizationEntries();

  /// Replaces matches of `RegExp(r'%s')` with given [arguments].
  ///
  /// **example:**
  /// ```dart
  /// print(replaceArguments('I love %s and %s!', ['cakes', 'pie'])) // 'I love cakes and pie!'
  /// ```
  String replaceArguments(
    String string, [
    List<String> arguments = const [],
  ]) {
    var regExp = RegExp(r'%s');

    // Lower between number of arguments and argument slots.
    var limit = min(arguments.length, regExp.allMatches(string).length);

    for (int i = 0; i < limit; i++) {
      string = string.replaceFirst(regExp, arguments[i]);
    }

    return string;
  }

${fields.join("\n\n")}
}
""";
}

/// Generate each Locale's extension of ModularLocalizationEntries.
String generateModularLocalizationEntriesForLocale(
  Metadata metadata,
  Locale locale,
) {
  var values = metadata.unnestedValues;

  var fields = <String>[];

  for (int i = 0; i < values.length; i++) {
    var value = values[i];

    var quotes = value.entries[locale]!.contains('\'') ? '"' : "'";

    var override = '  @override\n';

    var entry = value.entries[locale]!.replaceAll('\n', '\\n');

    // FIELD DOCUMENTATION
    var docstring = '  /// **"$entry"**\n';

    // GETTER / METHOD
    var field = value.immutable
        ? '  String get entry$i => $quotes$entry$quotes;'
        : '  String entry$i([List<String> args = const []]) => replaceArguments($quotes$entry$quotes, args);';

    fields.add(override + docstring + field);
  }

  return """
import 'modular_localization_entries.dart';

class ModularLocalizationEntries${locale.toPascalCase()} extends ModularLocalizationEntries {
  const ModularLocalizationEntries${locale.toPascalCase()}();

${fields.join("\n\n")}
}
""";
}
