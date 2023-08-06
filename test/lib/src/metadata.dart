import 'package:modular_localization/src/metadata.dart';
import 'package:test/test.dart';

void main() {
  test('', () {
    var metadata = Metadata(
      supportedLocales: [],
      group: Group(
        label: '',
        values: [],
        groups: [],
      ),
    );

    expect(metadata.group.nestedGroupCount, equals(0));
    expect(metadata.group.nestedValueCount, equals(0));
  });

  test('', () {
    var metadata = Metadata(
      supportedLocales: [],
      group: Group(
        label: '',
        values: [
          Value(
            label: '',
            entries: {},
          ),
        ],
        groups: [
          Group(
            label: '',
            values: [],
            groups: [],
          ),
        ],
      ),
    );

    expect(metadata.group.nestedGroupCount, equals(1));
    expect(metadata.group.nestedValueCount, equals(1));
  });

  test('', () {
    var metadata = Metadata(
      supportedLocales: [],
      group: Group(
        label: '',
        values: [],
        groups: [
          Group(
            label: '',
            values: [
              Value(
                label: '',
                entries: {},
              ),
            ],
            groups: [
              Group(
                label: '',
                values: [
                  Value(
                    label: '',
                    entries: {},
                  ),
                ],
                groups: [],
              ),
            ],
          ),
        ],
      ),
    );

    expect(metadata.group.nestedGroupCount, equals(2));
    expect(metadata.group.nestedValueCount, equals(2));
  });
}
