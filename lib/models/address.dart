

class Address {
  String? id;
  String? clientId;
  String? address;
  String? lat;
  String? lng;
  String? streetName;
  String? houseNumber;
  String? buildingName;
  String? floorDoorNumber;
  String? codePostal;
  String? city;
  Address({
    this.clientId,
    this.address,
    this.lat,
    this.lng,
    this.streetName,
    this.houseNumber,
    this.buildingName,
    this.floorDoorNumber,
    this.codePostal,
    this.city,
  });


  Map<String, dynamic> toMap() {
    return {
      'id':this.id,
      'client_id': this.clientId,
      'address': this.address??'',
      'lat': this.lat??'',
      'lng': this.lng??'',
      'street_name': this.streetName,
      'house_number': this.houseNumber??'',
      'building_name': this.buildingName??'',
      'floor_door_number': this.floorDoorNumber??'',
      'code_postal': this.codePostal??'',
      'city': this.codePostal??''
    };
  }

  Address.fromMap(Map<String, dynamic> map) {
    id = map['id'].toString();
    clientId = map['client_id'];
    address = map['address'];
    lat = map['lat'];
    lng = map['lng'];
    streetName = map['street_name'];
    houseNumber = map['house_number'];
    buildingName = map['building_name'];
    floorDoorNumber = map['floor_door_number'];
    codePostal = map['code_postal'];
    city = map['city'];
  }
}
