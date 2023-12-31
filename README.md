# modular_localization

A tool for generating string localizations.

## Getting started

modular_localization is built with modularity and intellisense in mind.

First, ensure the following is in your pubspec.yaml:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  modular_localization: ^1.0.0    
```

Then, import the flutter_localizations and the modular_localization libraries and specify localizationDelegates and supportedLocales for you application:

```dart
import 'package:modular_localization/modular_localization.dart';

return const MaterialApp(
  title: 'Modular Localization Sample App',
  localizationsDelegates: [
    ModularLocalization.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en', 'US'),
    Locale('pt', 'BR'),
  ],
  home: MyHomePage(),
);
```

You can also use your favorite state management solution to change the app's locale while running, by passing it in the MaterialApp's `locale` parameter and rebuilding the widget whenever the locale changes.

Now, write some .json files for your localized strings:

```json
en-US.json
{
    "greeting": "Hi, would you care for a cup of %s?",
    "drinks": {
        "tea": "tea",
        "coffee": "coffee"
    }
}
```

```json
pt-BR.json
{
    "greeting": "Olá, gostaria de uma xícara de %s?",
    "drinks": {
        "tea": "chá",
        "coffee": "café"
    }
}
```

## How to run

Depend on the package then run `dart run modular_localization [source directory] [target directory]`

You can optionally specify a source (`lib/l10n` by default) and target (`lib/l10n/generated`) directories, that is, where your .json files are and where your .dart files will go.

Now, all you have to do is import the generated `ModularLocalization` class and refer to the generated localizations:

```dart
import 'package:flutter/material.dart';

import '<target directory>/modular_localization.dart';

class MyWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var drink = ModularLocalization.localizations.drinks.coffee;
    var greeting = ModularLocalization.localizations.greeting([drink]);
    return Text('$greeting $world!'); // 'Olá, gostaria de uma xícara de café?' or 'Hi, would you care for a cup of coffee?' depending on the device's target Locale.
  }
}
```

## Limitations

+ Because of [how the Localizations widget works](https://docs.flutter.dev/accessibility-and-localization/internationalization), locale changes triggered by changing the system's locale might not reflect in updating the localization strings.
+ Your application must support at least one locale, even if it has no localized strings. That means setting up the locale.json file.