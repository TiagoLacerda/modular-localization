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

  /// `en-US`: **"Hi, would you care for a cup of %s?"**
  ///
  /// `pt-BR`: **"Olá, gostaria de uma xícara de %s?"**
  String entry0([List<String> args = const []]);

  /// `en-US`: **"coffee"**
  ///
  /// `pt-BR`: **"café"**
  String get entry1;

  /// `en-US`: **"tea"**
  ///
  /// `pt-BR`: **"chá"**
  String get entry2;
}
