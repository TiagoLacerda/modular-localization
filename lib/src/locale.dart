/// Language code: ISO 639 2 or 3, or 4 for future use, alpha.
///
/// Optional script code: ISO 15924 4 alpha.
///
/// Optional country code: ISO 3166-1 2 alpha or 3 digit.
///
/// Separated by underscores or dashes.
///
/// For more info, see: https://stackoverflow.com/questions/8758340/is-there-a-regex-to-test-if-a-string-is-for-a-locale.
///
class Locale {
  const Locale(
    this.languageCode, {
    this.scriptCode,
    this.countryCode,
  }) : assert(languageCode != '');

  /// Regular Expression that generates a valid `Locale`.
  static final regExp =
      RegExp(r'^[a-zA-Z]{2,4}([_-][a-zA-Z]{4})?([_-]([a-zA-Z]{2}|[0-9]{3}))?$');

  /// Parse [source] as an Locale.
  ///
  /// Throws a FormatException if [source] is not valid.
  static Locale parse(String source) {
    if (!Locale.regExp.hasMatch(source)) throw const FormatException();

    var codes = source.replaceAll('_', '-').split('-');

    String languageCode = codes[0];
    String? scriptCode;
    String? countryCode;

    if (codes.length == 2) {
      if (codes[1].length == 4) {
        // e.g. Locale.parse("en-Latn");
        scriptCode = codes[1];
      } else {
        // e.g. Locale.parse("en-US");
        countryCode = codes[1];
      }
    }

    // e.g. Locale.parse("en-Latn-US");
    if (codes.length == 3) {
      scriptCode = codes[1];
      countryCode = codes[2];
    }

    return Locale(
      languageCode,
      scriptCode: scriptCode,
      countryCode: countryCode,
    );
  }

  /// Parse [source] as an Locale.
  ///
  /// Returns null where a call to [parse] would throw a [FormatException].
  static Locale? tryParse(String source) {
    try {
      return parse(source);
    } catch (_) {
      return null;
    }
  }

  final String languageCode;

  final String? scriptCode;

  final String? countryCode;

  /// ### Example
  ///
  /// ```dart
  /// print(Locale("en", countryCode: "US").toLanguageTag()); // en-US
  /// ```
  String toLanguageTag([String separator = '-']) {
    var buffer = StringBuffer(languageCode);

    if (scriptCode != null && scriptCode!.isNotEmpty) {
      buffer.write('$separator$scriptCode');
    }

    if (countryCode != null && countryCode!.isNotEmpty) {
      buffer.write('$separator$countryCode');
    }

    return buffer.toString();
  }

  /// ### Example
  ///
  /// ```dart
  /// print(Locale("en", countryCode: "US").toPascalCase()); // EnUs
  /// ```
  String toPascalCase() {
    var buffer = StringBuffer();

    if (languageCode.isNotEmpty) {
      buffer.write(languageCode[0].toUpperCase());
    }

    if (languageCode.length > 1) {
      buffer.write(languageCode.substring(1).toLowerCase());
    }

    if (scriptCode != null) {
      if (scriptCode!.isNotEmpty) {
        buffer.write(scriptCode![0].toUpperCase());
      }

      if (scriptCode!.length > 1) {
        buffer.write(scriptCode!.substring(1).toLowerCase());
      }
    }

    if (countryCode != null) {
      if (countryCode!.isNotEmpty) {
        buffer.write(countryCode![0].toUpperCase());
      }

      if (countryCode!.length > 1) {
        buffer.write(countryCode!.substring(1).toLowerCase());
      }
    }

    return buffer.toString();
  }

  /// ### Example
  ///
  /// ```dart
  /// print(Locale("en", countryCode: "US").toSnakeCase()); // en_us
  /// ```
  String toSnakeCase() {
    var buffer = StringBuffer(languageCode.toLowerCase());

    if (scriptCode != null && scriptCode!.isNotEmpty) {
      buffer.write('_${scriptCode!.toLowerCase()}');
    }

    if (countryCode != null && countryCode!.isNotEmpty) {
      buffer.write('_${countryCode!.toLowerCase()}');
    }

    return buffer.toString();
  }

  @override
  String toString() => toLanguageTag();

  String toJson() => toString();
}
