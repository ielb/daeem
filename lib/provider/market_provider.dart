import 'dart:convert';
import 'package:daeem/models/item.dart';
import 'package:daeem/models/market.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/market_service.dart';
import 'package:http/http.dart';

class MarketProvider extends BaseProvider {
  List<Market> _markets = List.empty(growable: true);
  MarketService _marketService = MarketService();
  List<Market> _searchedMarkets = List.empty(growable: true);
  List<Market> get markets => _markets;
  double deliveryCost = 0;
  int _offset = 0;
  String? _storeType;
  String? get storeType => _storeType;

  //Todo:Remove market data from route arguments and use provider
  // Market? _currentMarket ;
  void setStoreType(String type){
    _storeType =type;
    notifyListeners();
  }
  _addMarket(Market market) {
    _markets.add(market);
  }

  setMarketFromJson(List data) {
    data.forEach((element) {
      _addMarket(Market.fromJson(element));
    });
    notifyListeners();
  }

  setSearchedMarkets(List data) {
    data.forEach((element) {
      _searchedMarkets.add(Market.fromJson(element));
    });
  }
 void setCost(double price){
    deliveryCost = price;
    notifyListeners();
  }

  Future<void> getDeliveryPrice(double price) async {
   
    Response? response = await _marketService.getDeliveryPrice();
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        data = data['data'];
        data.forEach((element) {
          if (price >= double.parse(element['price_from']) &&
              price <= double.parse(element['price_to'])) {
            setCost( double.parse(element['delivery_price']));
           
          }
         });   
      }
    }
    setBusy(false);
  }

  getPrice(List data) {}

  Future<bool> getMarkets() async {
    Response? response = await _marketService.getMarkets(_offset);
    _offset = _offset + 5;
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] != "error") {
        setMarketFromJson(data['data']);
        return true;
      } else
        return false;
    } else {
      return false;
    }
  }

  Future<List<Market>> getSearchedMarkets(String name) async {
    if (name.isEmpty || name == '') {
      return _markets;
    } else {
      Response? response = await _marketService.search(name);
      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] != "error") {
          data = data['data'];
          _searchedMarkets.clear();
          setSearchedMarkets(data);
          return _searchedMarkets;
        } else
          return List.empty();
      } else
        return List.empty();
    }
  }

  checkout(Client client,List<Item> cart,) async {
   
  }

    clear(){
  _markets = [];
  _offset = 0 ;
  _searchedMarkets = [];
  }
}
