import 'package:daeem/models/address.dart';
import 'package:daeem/provider/base_provider.dart';

class AddressProvider extends BaseProvider {
  Address? _address;
  Address? get address => _address;
  setAddress(Address? address){
    _address = address;
    notifyListeners();
  } 

  


}
