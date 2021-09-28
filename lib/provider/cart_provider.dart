

import 'package:daeem/models/item.dart';
import 'package:daeem/models/product.dart';
import 'package:daeem/provider/base_provider.dart';

class CartProvider extends BaseProvider {
    final List<Item> _basket = List.empty(growable: true);
   List<Item> get basket =>_basket;


  addToBasket(Item item){ 
    setBusy(true);
    if(_basket.isEmpty){
      _basket.add(item);
    }else{
       Item data = _basket.singleWhere((element) => item.product.id==element.product.id,orElse: () => Item(product: Product()));
     if(data.product.id==null){
       _basket.add(item);
     }else{ int index = _basket.indexOf(data);
       data.quantity ++;
       _basket[index] = data;
      
     }
    }
      print("Length :" +_basket.length.toString());
    _basket.forEach((element) {
      print("Product : "+element.product.name.toString()+"Quantity :  "+element.quantity.toString());
    });
    setBusy(false);
  }
  removeFromBasket(Item item){
    _basket.forEach((element) {
      if(element.product == item.product){
        element.quantity--;
      }else
      _basket.remove(item);
    });

  }
}