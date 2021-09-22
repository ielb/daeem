import 'package:daeem/services/base_api.dart';
import 'package:http/http.dart' as http;

class MarketService extends BaseApi {
  Future<http.Response?> getMarkets(int offset, {int limit = 5}) async {
    try {
      return await api.httpGet('supermarkets/$offset/$limit');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> getMarketById(int id) async {
    try {
      return await api.httpGet('supermarket/$id');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> search(String name) async {
    try {
      return await api.httpGet('supermarkets/$name');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> getMarketsHours(int id) async {
    try {
      return await api.httpGet('supermarket/$id/hours');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> getMarketsRating(int id) async {
    try {
      return await api.httpGet('supermarket/$id/rating');
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response?> updateMarketsRating(int marketId,int clientId,int rating) async {
    try {
      return await api.httpPost('supermarket/rating',
          {'supermarket_id': marketId,
           'rating_value': rating,
           'client_id': clientId
          });
    } catch (e) {
      print(e);
    }
  }
}
