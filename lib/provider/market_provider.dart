// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:daeem/models/address.dart';
import 'package:http/http.dart' as http;

import 'package:daeem/models/market.dart';
import 'package:daeem/models/store_type.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/store_service.dart';

class StoreProvider extends BaseProvider {
  List<Store> _markets = List.empty(growable: true);
  List<Store> get markets => _markets;
  StoreService _marketService = StoreService();
  List<Store> _searchedMarkets = List.empty(growable: true);
  List<StoreType> _storesTypes = List.empty(growable: true);
  List<StoreType> get storesType => _storesTypes;
  double deliveryCost = 0;
  String? _storeType;
  String? get storeType => _storeType;

  Store? _currentMarket;
  Store? get currentMarket => _currentMarket;

  setCurrentMarket(Store market) {
    _currentMarket = market;
    notifyListeners();
  }

  unSetCurrentMarket() {
    _currentMarket = null;
    notifyListeners();
  }

  void setStoreType(String type) {
    _storeType = type;
    notifyListeners();
  }

  _addMarket(Store market) {
    _markets.add(market);
  }

  setMarketFromJson(List data) {
    data.forEach((element) {
      _addMarket(Store.fromJson(element));
    });
    notifyListeners();
  }

  setSearchedMarkets(List data) {
    data.forEach((element) {
      _searchedMarkets.add(Store.fromJson(element));
    });
  }

  void setCost(double price) {
    deliveryCost = price;
    notifyListeners();
  }

  Future<void> getDeliveryPrice(double price) async {
    print(price);
    http.Response? response = await _marketService.getDeliveryPrice();
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        data = data['data'];
        data.forEach((element) {
          if (price >= double.parse(element['price_from']) &&
              price <= double.parse(element['price_to'])) {
            setCost(double.parse(element['delivery_price']));
          }
        });
        notifyListeners();
      }
    }
    setBusy(false);
  }

  Future<bool> getMarkets(Address address, String store_id) async {
    print(store_id);
    if (_markets.isNotEmpty) _markets.clear();
    http.Response? response = await _marketService.getStores(
        lng: address.lng!, lat: address.lat!, store_type: store_id);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        setMarketFromJson(data);
        return true;
      } else
        return false;
    } else {
      return false;
    }
  }

  Future<List<Store>> getSearchedMarkets(String name) async {
    if (name.isEmpty || name == '') {
      return _markets;
    } else {
      http.Response? response = await _marketService.search(name);
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

  Future<List<StoreType>> getStoreType() async {
    if (_storesTypes.isNotEmpty) return _storesTypes;
    try {
      http.Response? response = await _marketService.getStoreType();
      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] != "error") {
          data['data'][0].forEach(
              (element) => _storesTypes.add(StoreType.fromMap(element)));
          notifyListeners();
          if (_storesTypes.isNotEmpty) return _storesTypes;
        }
        notifyListeners();
        return List.empty(growable: true);
      }
      notifyListeners();
      return List.empty(growable: true);
    } catch (error) {
      print(error);
    }
    notifyListeners();
    return List.empty(growable: true);
  }

  clear() {
    _markets.clear();
    _storesTypes.clear();    
    _searchedMarkets.clear();
  }

  Future<List<StoreType>> getStores(Address address) async {
    if (_storesTypes.length == 0) {
      return List.empty(growable: true);
    } else {
      for (int i = 0; i < _storesTypes.length; i++) {
        if (_storesTypes[i].stores.length == 0) {
          http.Response? response = await _marketService.getStores(
              lat: address.lat!,
              lng: address.lng!,
              store_type: _storesTypes[i].id);
          if (response != null && response.statusCode == 200) {
            var data = jsonDecode(response.body);
            data.forEach((element) {
              if (element['store_type_id'].toString() == _storesTypes[i].id) {
                _storesTypes[i].stores.add(Store.fromJson(element));
              }
            });
          }notifyListeners();
        }
      }
      
      return _storesTypes;
    }
  }


  Future<void> rate(int id, int clientId ,int rate) async {
    http.Response? response = await _marketService.updateMarketsRating(id, clientId, rate);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        notifyListeners();
      }
    }
    }
}
