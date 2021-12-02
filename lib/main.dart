import 'package:daeem/configs/notification_manager.dart';
import 'package:daeem/models/order.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/auth_provider.dart';
import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/provider/notifiation_provider.dart';
import 'package:daeem/provider/orders_provider.dart';
import 'package:daeem/screens/cart_screen.dart';
import 'package:daeem/screens/checkout_screen.dart';
import 'package:daeem/screens/client/add_address.dart';
import 'package:daeem/screens/client/change_address.dart';
import 'package:daeem/screens/client/change_password.dart';
import 'package:daeem/screens/client/change_phone.dart';
import 'package:daeem/screens/client/phone_verification.dart';
import 'package:daeem/screens/confirmed_screen.dart';
import 'package:daeem/screens/connection.dart';
import 'package:daeem/screens/notification_screen.dart';
import 'package:daeem/screens/order_details_screen.dart';
import 'package:daeem/screens/order_screen.dart';
import 'package:daeem/screens/password/password_reset.dart';
import 'package:daeem/screens/product_details.dart';
import 'package:daeem/screens/products_screen.dart';
import 'package:daeem/screens/store_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/services.dart';
import 'screens/setup.dart';
import 'package:daeem/screens/sub_category.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
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
  await dotenv.load();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: dotenv.env['firebase_api_key']!,
          appId: dotenv.env['firebase_app_id']!,
          messagingSenderId: dotenv.env['firebase_messaging_sender_id']!,
          projectId:dotenv.env['firebase_project_id']!));
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => StoreProvider()),
    ChangeNotifierProvider(create: (context) => CategoryProvider()),
    ChangeNotifierProvider(create: (context) => CartProvider()),
    ChangeNotifierProvider(create: (context) => ClientProvider()),
    ChangeNotifierProvider(create: (context) => AddressProvider()),
    ChangeNotifierProvider(create: (context) => OrdersProvider()),
    ChangeNotifierProvider(create: (context) => NotificationProvider()),
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

 
    case LostConnection.id:
      return CupertinoPageRoute(
          builder: (_) => LostConnection(), settings: settings);
    case ConfirmedPage.id:
      return CupertinoPageRoute(
          builder: (_) => ConfirmedPage(), settings: settings);

    /// Home screen
    case Home.id:
      return CupertinoPageRoute(builder: (_) => Home(), settings: settings);
    case ResetPasswordPage.id:
      return CupertinoPageRoute(
          builder: (_) => ResetPasswordPage(), settings: settings);

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

    /// Settings
    case Setting.id:
      return CupertinoPageRoute(builder: (_) => Setting(), settings: settings);


    case Category.id:
      return CupertinoPageRoute(builder: (_) => Category(category: settings.arguments as String,), settings: settings);
    case CheckoutPage.id:
      return CupertinoPageRoute(
          builder: (_) => CheckoutPage(), settings: settings);

    case ProductsPage.id:
      return CupertinoPageRoute(
          builder: (_) => ProductsPage(), settings: settings);
          case ProductDetails.id:
      return CupertinoPageRoute(
          builder: (_) => ProductDetails(product : settings.arguments as Product), settings: settings);
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
    case OrderDetails.id:
      return CupertinoPageRoute(
          builder: (_) => OrderDetails(order: settings.arguments as Order), settings: settings);
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
