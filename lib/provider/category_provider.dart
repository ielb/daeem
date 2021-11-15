import 'dart:convert';

import 'package:daeem/models/market_category.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/models/sub_category.dart';
import 'package:daeem/provider/base_provider.dart';
import 'package:daeem/services/store_service.dart';
import 'package:http/http.dart';

class CategoryProvider extends BaseProvider {
  StoreService _service = StoreService();
  //*Market Category
  List<MarketCategory> _categories = List.empty(growable: true);
  List<MarketCategory> get categories => _categories;
  List<MarketCategory> _searchedCategories = List.empty(growable: true);
  //*Sub category
  List<SubCategory> _subCategories = List.empty(growable: true);
  List<SubCategory> get subCategories => _subCategories;
  List<SubCategory> _searchedSubCategories = List.empty(growable: true);
  //*Sub category products
  List<Product> _products = List.empty(growable: true);
  List<Product> get products => _products;
  List<Product> _searchedProducts = List.empty(growable: true);

  _addCategory(MarketCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  _setCategoryFromJson(List data) {
    data.forEach((element) {
      _addCategory(MarketCategory.fromJson(element));
    });
    notifyListeners();
  }

  _addSubCategory(SubCategory category) {
    _subCategories.add(category);
    notifyListeners();
  }

  _setSubCategoryFromJson(List data) {
    data.forEach((element) {
      _addSubCategory(SubCategory.fromJson(element));
    });
    notifyListeners();
  }

  _setSearchedCategories(List data) {
    data.forEach((element) {
      _searchedCategories.add(MarketCategory.fromJson(element));
    });
    notifyListeners();
  }

  _setSearchedSubCategories(List data) {
    data.forEach((element) {
      _searchedSubCategories.add(SubCategory.fromJson(element));
    });
    notifyListeners();
  }

  _addProducts(Product product) {
    _products.add(product);
    notifyListeners();
  }

  _setProductsFormJson(List data) {
    data.forEach((element) {
      _addProducts(Product.fromMap(element));
    });
    notifyListeners();
  }

  _setSearchedProducts(List data) {
    data.forEach((element) {
      _searchedProducts.add(Product.fromMap(element));
    });
    notifyListeners();
  }

  Future<bool> getProducts(int id) async {
    Response? response = await _service.getProducts(id);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] != "error") {
        _setProductsFormJson(data['data']);
        notifyListeners();
        return true;
      } else
        return false;
    } else
      return false;
  }

  /// -----------------   Product Variant ............................ ///

  // Future<List<Variant>> getProductVariant(int id) async {
  //   List<Variant> variants = List.empty(growable: true);
  //   setBusy(true);
  //   Response? response = await _service.getProductVariant(id);
  //   if (response != null && response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     if (data['status'] != "error") {
  //       print(data['data'][0]);
  //       data['data'][0].forEach((variant) {
  //         variants.add(Variant.fromMap(variant));
  //       });

  //       variants.forEach((vari) {
  //         print(vari.toString());
  //       });

  //       setBusy(false);
  //       return variants;
  //     } else {
  //       setBusy(false);
  //       return List.empty(growable: true);
  //     }
  //   } else {
  //     setBusy(false);
  //     return List.empty(growable: true);
  //   }
  // }

  Future<List<Product>> searchForProduct(String name) async {
    if (name.isEmpty || name == '') {
      return _products;
    } else {
      Response? response = await _service.searchProducts(name);
      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] != "error") {
          data = data['data'];
          _searchedProducts.clear();
          _setSearchedProducts(data);
          notifyListeners();
          return _searchedProducts;
        } else
          return List.empty();
      } else
        return List.empty();
    }
  }

  clearSearchedProducts() {
    _searchedProducts.clear();
    notifyListeners();
  }

  Future<bool> getCategories(int id) async {
    if (_categories.isNotEmpty) _categories.clear();
    Response? response = await _service.getMarketsCategory(id);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] != "error") {
        _setCategoryFromJson(data['data']);
        notifyListeners();
        return true;
      } else
        return false;
    } else
      return false;
  }

  Future<List<MarketCategory>> searchForCategories(String name) async {
    if (name.isEmpty || name == '') {
      return _categories;
    } else {
      Response? response = await _service.searchForCategory(name);
      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] != "error") {
          data = data['data'];
          _searchedCategories.clear();
          _setSearchedCategories(data);
          notifyListeners();
          return _searchedCategories;
        } else
          notifyListeners();
        return List.empty();
      } else
        notifyListeners();
      return List.empty();
    }
  }

  clearSearched() {
    _searchedCategories.clear();
    notifyListeners();
  }

  clearSubSearched() {
    _searchedSubCategories.clear();
    notifyListeners();
  }

  closeProducts() {
    _products.clear();
  }

  close() {
    _categories.clear();
  }
  // * Subcategories

  Future<bool> getSubCategories(int id) async {
    _subCategories.clear();
    Response? response = await _service.getMarketsSubCategory(id);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] != "error") {
        _setSubCategoryFromJson(data['data']);
        return true;
      } else
        return false;
    } else
      return false;
  }

  Future<List<SubCategory>> searchForSubCategories(String name) async {
    setBusy(true);
    if (name.isEmpty || name == '') {
      return _subCategories;
    } else {
      Response? response = await _service.searchForSubCategory(name);
      if (response != null && response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] != "error") {
          data = data['data'];
          _searchedSubCategories.clear();
          _setSearchedSubCategories(data);
          setBusy(false);
          return _searchedSubCategories;
        } else
          setBusy(false);
        return List.empty();
      } else
        setBusy(false);
      return List.empty();
    }
  }

  closeSub() {
    _subCategories.clear();
  }
}
