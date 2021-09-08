import 'package:daeem/l10n/l10n.dart';
import 'package:daeem/provider/locale_provider.dart';
import 'package:daeem/screens/home.dart';
import 'package:daeem/screens/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'services/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (BuildContext context, Widget? child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GESTY',
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: provider.locale,
          onGenerateRoute: routes,
          initialRoute: Splash.id,
        );
      },
      create: (BuildContext context) => LocaleProvider(),
    );
  }
}

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {

    /// Splash screen
    case Splash.id:
      return CupertinoPageRoute(builder: (_) => Splash(), settings: settings);

    /// Home screen
    case Home.id:
      return CupertinoPageRoute(builder: (_) => Home(), settings: settings);

    ///
    /// Default route in case of error
    default:
      return CupertinoPageRoute(builder: (_) => Splash(), settings: settings);
  }
}
