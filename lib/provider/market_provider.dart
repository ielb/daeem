// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:daeem/models/client.dart';
import 'package:http/http.dart' as http;

import 'package:daeem/models/market.dart';
import 'package:daeem/models/store_type.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/market_service.dart';

class MarketProvider extends BaseProvider {
  List<Market> _markets = List.empty(growable: true);
  List<Market> get markets => _markets;
  MarketService _marketService = MarketService();
  List<Market> _searchedMarkets = List.empty(growable: true);
  List<StoreType> _storesTypes = List.empty(growable: true);
  List<StoreType> get storesType => _storesTypes;
  double deliveryCost = 0;
  int _offset = 0;
  String? _storeType;
  String? get storeType => _storeType;

  Market? _currentMarket;
  Market? get currentMarket => _currentMarket;

  setCurrentMarket(Market market) {
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

  void setCost(double price) {
    deliveryCost = price;
    notifyListeners();
  }

  Future<void> getDeliveryPrice(double price) async {
    http.Response? response = await _marketService.getDeliveryPrice();
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        data = data['data'];
        print(data);
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

  getPrice(List data) {}

  Future<bool> getMarkets() async {
    http.Response? response = await _marketService.getMarkets(_offset);
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

  Future<bool> getStoreType() async {
    if (_storesTypes.isNotEmpty) return true;
    try {
      http.Response? response = await _marketService.getStoreType();
      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] != "error") {
          data['data'][0].forEach(
              (element) => _storesTypes.add(StoreType.fromMap(element)));
          notifyListeners();
          return true;
        }
        notifyListeners();
        return false;
      }
      notifyListeners();
      return false;
    } catch (error) {
      print(error);
    }
    notifyListeners();
    return false;
  }

  clear() {
    _markets = [];
    _offset = 0;
    _searchedMarkets = [];
  }

  List<TypedStores> _typedStores = List.empty(growable: true);
  List<TypedStores> get typedStores => _typedStores;

  Future<List<TypedStores>> getTypedStores(Client client) async {
    if (_storesTypes.isEmpty) {
      return List.empty(growable: true);
    } else {
      print(_storesTypes.length);
      for (var i = 0; i < _storesTypes.length; i++) {
         http.Response? response = await _marketService.getTypedStores(
            lat: client.address?.lat ?? '',
            lng: client.address?.lng ?? '',
            store_type: _storesTypes[i].id ?? '1');
            print(response?.body);
        if (response != null && response.statusCode == 200) {
          var data = jsonDecode(response.body);
          // print(data);
          data.forEach((element){
            if(element['store_type_id'].toString() == _storesTypes[i].id ){
              TypedStores stores = TypedStores(store_type: _storesTypes[i].name??'Grecery');
              stores.stores.add(Market.fromJson(element));
              _typedStores.add(stores);
            }
          });
         
        } 
      }
    }
    print( _typedStores.length);

    return List.empty(growable: true);
  }
}

class TypedStores {
  String store_type;
  TypedStores({
    required this.store_type,
  });
  List<Market> stores = List.empty(growable: true);

  TypedStores copyWith({
    String? store_type,
  }) {
    return TypedStores(
      store_type: store_type ?? this.store_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'store_type': store_type,
    };
  }

  factory TypedStores.fromMap(Map<String, dynamic> map) {
    return TypedStores(
      store_type: map['store_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TypedStores.fromJson(String source) =>
      TypedStores.fromMap(json.decode(source));

  @override
  String toString() => 'TypedStores(store_type: $store_type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TypedStores && other.store_type == store_type;
  }

  @override
  int get hashCode => store_type.hashCode;
}
