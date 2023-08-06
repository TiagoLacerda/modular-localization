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
    Locale('en-US'),
    Locale('pt-BR'),
  ],
  home: MyHomePage(),
);
```

Now, write some .json files for your localized strings:

```json
en-US.json
{
    "greeting": "Welcome, %s, to planet",
    "worlds": {
        "earth": "Earth",
        "mars": "Mars",
    }
}
```

```json
pt-BR.json
{
    "greeting": "Bem-vindo, %s, ao planeta",
    "worlds": {
        "earth": "Terra",
        "mars": "Marte",
    }
}
```

## How to run

Depend on the package then run `dart run modular_localization [source directory] [target directory]`

You can optionally specify a source (`l10n` by default) and target (`l10n/generated`) directories, that is, where your .json files are and where your .dart files will go.

Now, all you have to do is import the generated `ModularLocalization` class and refer to the generated localizations:

```dart
import 'package:flutter/material.dart';

import '<target directory>/modular_localization.dart';

class MyWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var greeting = ModularLocalization.localizations.hello(context, ['Han Solo']);
    var world = ModularLocalization.localizations.worlds.earth(context);
    return Text('$greeting $world!'); // 'Welcome, Han Solo, to planet Earth!' or 'Bem-vindo, Han Solo, ao planeta Terra!' depending on the device's target Locale.
  }
}
```

## Limitations

+ Because of [how the Localizations widget works](https://docs.flutter.dev/accessibility-and-localization/internationalization), to ensure the application will rebuild where needed after changing the device's Locale, it is necessary to pass the BuildContext. If you do not care about Locale changes while the app is running, you can ommit the BuildContext.