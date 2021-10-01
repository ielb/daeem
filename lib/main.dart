import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/provider/locator.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/checkout_screen.dart';
import 'package:daeem/screens/confirmed_screen.dart';
import 'package:daeem/screens/map_screen.dart';
import 'package:daeem/screens/products_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'screens/email/verify_email.dart';
import 'services/services.dart';
import 'screens/setup.dart';
import 'package:daeem/screens/sub_category.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => MarketProvider()),
    ChangeNotifierProvider(create: (context) => CategoryProvider()),
    ChangeNotifierProvider(create: (context) => CartProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (BuildContext context, Widget? child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Daeem',
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
      return CupertinoPageRoute(builder: (_) => Setup(), settings: settings);

    case MapScreen.id:
      return CupertinoPageRoute(
          builder: (_) => MapScreen(), settings: settings);
    case ConfirmedPage.id:
      return CupertinoPageRoute(
          builder: (_) => ConfirmedPage(), settings: settings);

    /// Home screen
    case Home.id:
      return CupertinoPageRoute(builder: (_) => Home(), settings: settings);

    /// On boarding
    case OnBoardering.id:
      return CupertinoPageRoute(
          builder: (_) => OnBoardering(), settings: settings);

    ///Login
    case Login.id:
      return CupertinoPageRoute(builder: (_) => Login(), settings: settings);

    /// Sign up
    case SignUp.id:
      return CupertinoPageRoute(builder: (_) => SignUp(), settings: settings);

    /// Market
    case MarketPage.id:
      return CupertinoPageRoute(
          builder: (_) => MarketPage(), settings: settings);

    /// Profile
    case Profile.id:
      return CupertinoPageRoute(builder: (_) => Profile(), settings: settings);

    case VerifyEmail.id:
      return CupertinoPageRoute(
          builder: (_) => VerifyEmail(), settings: settings);

    /// Settings
    case Setting.id:
      return CupertinoPageRoute(builder: (_) => Setting(), settings: settings);

    case MapScreen.id:
      return CupertinoPageRoute(
          builder: (_) => MapScreen(), settings: settings);

    case Category.id:
      return CupertinoPageRoute(builder: (_) => Category(), settings: settings);
    case CheckoutPage.id:
      return CupertinoPageRoute(
          builder: (_) => CheckoutPage(), settings: settings);

    case ProductsPage.id:
      return CupertinoPageRoute(
          builder: (_) => ProductsPage(), settings: settings);

    /// Default route in case of error
    default:
      return CupertinoPageRoute(builder: (_) => Setup(), settings: settings);
  }
}
