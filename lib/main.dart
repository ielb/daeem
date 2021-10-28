import 'package:daeem/configs/notification_manager.dart';
import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/screens/cart_screen.dart';
import 'package:daeem/screens/checkout_screen.dart';
import 'package:daeem/screens/client/add_address.dart';
import 'package:daeem/screens/client/change_address.dart';
import 'package:daeem/screens/client/change_password.dart';
import 'package:daeem/screens/client/change_phone.dart';
import 'package:daeem/screens/client/phone_verification.dart';
import 'package:daeem/screens/confirmed_screen.dart';
import 'package:daeem/screens/connection.dart';
import 'package:daeem/screens/map_screen.dart';
import 'package:daeem/screens/notification_screen.dart';
import 'package:daeem/screens/order_screen.dart';
import 'package:daeem/screens/products_screen.dart';
import 'package:daeem/screens/store_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'screens/email/verify_email.dart';
import 'services/services.dart';
import 'screens/setup.dart';
import 'package:daeem/screens/sub_category.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(" data ${message.data['title']}");
  notifyManager.showNotification(
      5, message.notification?.title??message.data['title'], message.notification?.body ?? message.data['body']);
  notifyManager.setOnNotificationClick(onNotificationClick);
  notifyManager.setOnNotificationReceive(onNotificationReceive);
}

onNotificationClick(String? notification) {
  print("Notification Received : $notification");
}

onNotificationReceive(notification) {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyD06NHrE7Q0bvZKU4bbb_iCu_JbwuIhp7U',
          appId: "1:754880333308:android:24877d09b33939c6749e79",
          messagingSenderId: '754880333308',
          projectId: 'daeem-10b87'));
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => MarketProvider()),
    ChangeNotifierProvider(create: (context) => CategoryProvider()),
    ChangeNotifierProvider(create: (context) => CartProvider()),
    ChangeNotifierProvider(create: (context) => ClientProvider()),
    ChangeNotifierProvider(create: (context) => AddressProvider())
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
    case LostConnection.id:
      return CupertinoPageRoute(
          builder: (_) => LostConnection(), settings: settings);
    case ConfirmedPage.id:
      return CupertinoPageRoute(
          builder: (_) => ConfirmedPage(), settings: settings);

    /// Home screen
    case Home.id:
      return CupertinoPageRoute(builder: (_) => Home(), settings: settings);

    case OrdersPage.id:
      return CupertinoPageRoute(
          builder: (_) => OrdersPage(), settings: settings);

    /// On boarding
    case OnBoardering.id:
      return CupertinoPageRoute(
          builder: (_) => OnBoardering(), settings: settings);

    case Store.id:
      return CupertinoPageRoute(builder: (_) => Store(), settings: settings);

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
    case AddressPage.id:
      return CupertinoPageRoute(
          builder: (_) => AddressPage(), settings: settings);

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
    case ChangePassword.id:
      return CupertinoPageRoute(
          builder: (_) => ChangePassword(), settings: settings);
    case ChangePhone.id:
      return CupertinoPageRoute(
          builder: (_) => ChangePhone(), settings: settings);
    case ChangeAddress.id:
      return CupertinoPageRoute(
          builder: (_) => ChangeAddress(), settings: settings);
    case CartPage.id:
      return CupertinoPageRoute(builder: (_) => CartPage(), settings: settings);

    case NotificationScreen.id:
      return CupertinoPageRoute(
          builder: (_) => NotificationScreen(), settings: settings);
    case Verification.id:
      return CupertinoPageRoute(
          builder: (_) => Verification(), settings: settings);

    /// Default route in case of error
    default:
      return CupertinoPageRoute(builder: (_) => Setup(), settings: settings);
  }
}
