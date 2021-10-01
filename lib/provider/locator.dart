



import 'package:daeem/provider/cart_provider.dart';
import 'package:daeem/provider/category_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:get_it/get_it.dart';

import 'auth_provider.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerFactory<CartProvider>(() => CartProvider());
  locator.registerFactory<AuthProvider>(() => AuthProvider());
  locator.registerFactory<CategoryProvider>(() => CategoryProvider());
  locator.registerFactory<ClientProvider>(() => ClientProvider());

}
