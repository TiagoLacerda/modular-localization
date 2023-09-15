import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/generated/modular_localization.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var locale = const Locale('pt', 'BR');

  void updateLocale(Locale locale) {
    setState(() {
      this.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular Localization Sample App',
      locale: locale,
      localizationsDelegates: const [
        ModularLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      home: MyHomePage(
        updateLocale: updateLocale,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
    required this.updateLocale,
  });

  final void Function(Locale) updateLocale;

  @override
  Widget build(BuildContext context) {
    var drink = ModularLocalization.localizations.drinks.coffee;
    var greeting = ModularLocalization.localizations.greeting([drink]);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(greeting),
            ElevatedButton(
              onPressed: () => updateLocale(const Locale('pt', 'BR')),
              child: const Text('pt-BR'),
            ),
            ElevatedButton(
              onPressed: () => updateLocale(const Locale('en', 'US')),
              child: const Text('en-US'),
            ),
          ],
        ),
      ),
    );
  }
}
