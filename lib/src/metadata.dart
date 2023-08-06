import 'locale.dart';

/// Data about l10n generation, including supported locales and nested key-value
/// pairs.
class Metadata {
  Metadata({
    required this.supportedLocales,
    required this.group,
  });

  List<Locale> supportedLocales;
  Group group;

  /// Merge new localizations from [map] for [locale] into this instance of
  /// [Metadata].
  void merge(
    Map<String, dynamic> map,
    Locale locale,
  ) {
    group.merge(map, locale);
  }

  /// Returns a list of every `Value` in this `Metadata`, however deeply nested,
  /// preserving their order.
  List<Value> get unnestedValues => _unnest(group);

  /// Returns a list of every `Value` in a `Group`, however deeply nested,
  /// preserving their order.
  ///
  /// ### Example
  ///
  /// ```dart
  /// var group = Group(
  ///   label: "",
  ///   values: [
  ///     Value(
  ///       label: "foo",
  ///       entries: {Locale("en", countryCode: "US"): "bar"}
  ///     ),
  ///   ],
  ///   groups: [
  ///     Group(
  ///       label: "",
  ///       values: [
  ///         Value(
  ///           label: "baz",
  ///           entries: {Locale("en", countryCode: "US"): "qux"}
  ///         ),
  ///       ],
  ///       groups: [],
  ///     ),
  ///   ],
  /// );
  ///
  /// return _unnest(group);
  /// ```
  ///
  /// #### returns
  ///
  /// ```dart
  /// [
  ///   Value(
  ///     label: "foo",
  ///     entries: {Locale("en", countryCode: "US"): "bar"}
  ///   ),
  ///   Value(
  ///     label: "baz",
  ///     entries: {Locale("en", countryCode: "US"): "qux"}
  ///   ),
  /// ]
  /// ```
  static List<Value> _unnest(Group group) {
    var values = <Value>[];

    values.addAll(group.values);

    for (var subgroup in group.groups) {
      values.addAll(_unnest(subgroup));
    }

    return values;
  }

  Map<String, dynamic> toMap() {
    return {
      'supportedLocales': supportedLocales,
      'group': group.toMap(),
    };
  }

  Map<String, dynamic> toJson() => toMap();
}

/// Class corresponding to a <String, Map> pair in an l10n .json file.
///
/// ### Example
/// ```json
/// {
///   "foo": {}
/// }
/// ```
///
/// #### equates to
///
/// ```dart
/// Group(label: "foo", values: [], groups: []);
/// ```
class Group {
  Group({
    required this.label,
    required this.values,
    required this.groups,
  });

  final String label;
  List<Value> values;
  List<Group> groups;

  int get nestedGroupCount {
    int count = groups.length;

    for (var group in groups) {
      count += group.nestedGroupCount;
    }

    return count;
  }

  int get nestedValueCount {
    int count = values.length;

    for (var group in groups) {
      count += group.nestedValueCount;
    }

    return count;
  }

  /// Merge new localizations from [map] for [locale] into this instance of
  /// [Group].
  void merge(
    Map<String, dynamic> map,
    Locale locale,
  ) {
    for (var key in map.keys) {
      var regExp = RegExp(r'^[a-z]+[a-zA-Z0-9]*$');

      // COMPLAIN IF KEY IS NOT CAMELCASE.
      if (!regExp.hasMatch(key)) {
        throw FormatException(
          "Keys must be in lowerCamelCase! Invalid value: '$key'.",
        );
      }

      if (map[key] is String) {
        // Example:
        // en-US: {
        //   "foo": {
        //     "bar": "baz"
        //   }
        // }
        //
        // pt-BR: {
        //   "foo": "bar"
        // }
        //
        if (groups.where((e) => e.label == key).isNotEmpty) {
          throw const FormatException(
            'Mismatch! Corresponding objects have different types between files. This usually happens when two source files do not follow the same structure.',
          );
        }

        //
        if (values.where((e) => e.label == key).isEmpty) {
          values.add(Value(
            label: key,
            entries: {},
          ));
        }

        //
        for (var value in values.where((e) => e.label == key)) {
          value.entries[locale] = map[key];
          if (map[key].contains('%s')) value.immutable = false;
        }
      } else if (map[key] is Map) {
        // Example:
        // en-US: {
        //   "foo": "bar"
        // }
        //
        // pt-BR: {
        //   "foo": {
        //     "bar": "baz"
        //   }
        // }
        //
        if (values.where((e) => e.label == key).isNotEmpty) {
          throw const FormatException(
            'Mismatch! Corresponding objects have different types between files. This usually happens when two source files do not follow the same structure.',
          );
        }

        //
        if (groups.where((e) => e.label == key).isEmpty) {
          groups.add(Group(
            label: key,
            values: [],
            groups: [],
          ));
        }

        //
        for (var group in groups.where((e) => e.label == key)) {
          group.merge(
            map[key],
            locale,
          );
        }
      } else {
        throw FormatException(
          'Cannot convert this object into an l10n entry. Type: ${map[key].runtimeType}.',
        );
      }
    }

    values.sort((a, b) => a.label.compareTo(b.label));
    groups.sort((a, b) => a.label.compareTo(b.label));
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'values': values.map((e) => e.toMap()).toList(),
      'groups': groups.map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toJson() => toMap();
}

/// Class corresponding to a `<String, String>` pair in an l10n .json file.
///
/// #### Example `en-US.json:`
///
/// ```json
/// {
///   "foo": "bar"
/// }
/// ```
///
/// #### Equates to
///
/// ```dart
/// Value(label: "foo", entries: {"en-US": "bar"});
/// ```
class Value {
  Value({
    required this.label,
    required this.entries,
    this.immutable = true,
  });

  final String label;
  Map<Locale, String> entries;

  /// Whether any localized string in this value allows for arguments.
  bool immutable;

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'entries': {
        for (var key in entries.keys) key.toString(): entries[key],
      },
      'immutable': immutable,
    };
  }

  Map<String, dynamic> toJson() => toMap();
}
