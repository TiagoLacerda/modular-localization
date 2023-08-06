import 'package:modular_localization/src/locale.dart';
import 'package:test/test.dart';

void main() {
  test('toLanguageTag()', () {
    expect(
      const Locale('en').toLanguageTag(),
      equals('en'),
    );
    expect(
      const Locale('en', countryCode: 'US').toLanguageTag(),
      equals('en-US'),
    );
  });

  test('toPascalCase()', () {
    expect(
      const Locale('en').toPascalCase(),
      equals('En'),
    );
    expect(
      const Locale('en', countryCode: 'US').toPascalCase(),
      equals('EnUs'),
    );
  });

  test('toSnakeCase()', () {
    expect(
      const Locale('en').toSnakeCase(),
      equals('en'),
    );
    expect(
      const Locale('en', countryCode: 'US').toSnakeCase(),
      equals('en_us'),
    );
  });
}
