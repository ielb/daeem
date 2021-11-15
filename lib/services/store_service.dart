// ignore_for_file: non_constant_identifier_names

import 'package:daeem/services/base_api.dart';
import 'package:http/http.dart' as http;

class StoreService extends BaseApi {
  Future<http.Response?> getMarkets(int offset, {int limit = 5}) async {
    try {
      return await api.httpGet('stores/$offset/$limit');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> getMarketById(int id) async {
    try {
      return await api.httpGet('store/$id');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> search(String name) async {
    try {
      return await api.httpGet('stores/$name');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> getMarketsHours(int id) async {
    try {
      return await api.httpGet('store/$id/hours');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> getMarketsRating(int id) async {
    try {
      return await api.httpGet('store/$id/rating');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> updateMarketsRating(int marketId,int clientId,int rating) async {
    try {
      return await api.httpPost('store/rating',
          {'store_id': marketId,
           'rating_value': rating,
           'client_id': clientId
          });
    } catch (e) {
      print(e);
    }
  }


    Future<http.Response?> getMarketsCategory(int id) async {
    try {
      return await api.httpGet('store/$id/categories');
    } catch (e) {
      throw e;
    }
  }
   Future<http.Response?> searchForCategory(String name) async {
    try {
      return await api.httpGet('categories/$name');
    } catch (e) {
      print(e);
    }
  }
 Future<http.Response?> searchForSubCategory(String name) async {
    try {
      return await api.httpGet('subcategories/$name');
    } catch (e) {
      print(e);
    }
  }

   Future<http.Response?> getMarketsSubCategory(int id) async {
    try {
      return await api.httpGet('category/$id/subcategories');
    } catch (e) {
      throw e;
    }
  }
  Future<http.Response?> getProducts(int id) async {
    try {
      return await api.httpGet('subcategory/$id/products');
    } catch (e) {
      throw e;
    }
    }
  Future<http.Response?> searchProducts(String name) async {
    try {
      return await api.httpGet('products/search/$name');
    } catch (e) {
      throw e;
    }
  }
   Future<http.Response?> checkCoupon(String name) async {
    try {
      return await api.httpGet('coupon/$name');
    } catch (e) {
      throw e;
    }
  }
    Future<http.Response?> getDeliveryPrice() async {
    try {
      return await api.httpGet('delivery_setting');
    } catch (e) {
      throw e;
    }
  }

   Future<http.Response?> getProductVariant(id) async {
    try {
      return await api.httpGet('product/$id');
    } catch (e) {
      throw e;
    }
  }
   Future<http.Response?> getStoreType() async {
    try {
      return await api.httpGet('stores_types');
    } catch (e) {
      throw e;
    }
  }
 Future<http.Response?> getStores({required String lng,required String lat,required String store_type}) async {
    try {
      return await api.httpPost('stores_by_type',
          {
            'store_type': store_type,
           'lat': lat,
           'lng': lng
          });
    } catch (e) {
      print(e);
    }
  }


}
