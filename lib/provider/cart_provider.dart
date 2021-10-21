import 'package:daeem/models/item.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/provider/base_provider.dart';

class CartProvider extends BaseProvider {
  List<Item> _basket = List.empty(growable: true);
  List<Item> get basket => _basket;

 bool addToBasket(Item item) {
    if (_basket.isEmpty) {
      _basket.add(item);
      return true;
    } else {
      Item data = _basket.singleWhere(
          (element) => item.product.id == element.product.id,
          orElse: () => Item(product: Product()));
      if (data.product.id == null) {
        _basket.add(item);

        notifyListeners();
        return true;
      } else {
        int index = _basket.indexOf(data);
        data.quantity++;
        _basket[index] = data;
        notifyListeners();
        return false;
      }
    }
  }

  removeFromBasket(Item item) {
    if (_basket.isEmpty) {
      notifyListeners();
      return;
    } else {
      Item data = _basket.singleWhere(
          (element) => item.product.id == element.product.id,
          orElse: () => Item(product: Product()));
      if (data.product.id != null) {
        if (data.quantity <= 0) {
          _basket.remove(data);
          notifyListeners();
          return;
        } else {
          int index = _basket.indexOf(data);
          data.quantity--;
          if (data.quantity <= 0) {
            _basket.remove(data);
            notifyListeners();
            return;
          } else
            _basket[index] = data;
          notifyListeners();
        }
      }
    }
    notifyListeners();
   
  }
  bool deleteItem(Item item){
     return _basket.remove(item);
  }

  clearCart() {
    _basket.clear();
    notifyListeners();
  }

  bool isCartEmpty() {
    return _basket.isEmpty ? true : false;
  }

  String getFinalPrice() {
    double price = 0;
    _basket.forEach((element) {
      price =
          (double.tryParse(element.product.price!)! * element.quantity) + price;
    });
    return price.toStringAsFixed(2);
  }
}
