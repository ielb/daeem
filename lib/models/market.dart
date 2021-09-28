import 'dart:convert';

import 'package:daeem/services/market_service.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Market {
  int? id;
  String? name;
  String? logo;
  String? cover;
  String? phone;
  String? address;
  String? cityId;
  String? description;
  String? lat;
  String? lng;
  bool? isFakeRating;
  bool? status;
  int? rating = 5;
  String hours = "07:00 - 22:00";

  Market(
      {this.id,
      this.name,
      this.logo,
      this.cover,
      this.phone,
      this.address,
      this.cityId,
      this.description,
      this.lat,
      this.lng,
      this.isFakeRating,
      this.status,
      this.rating,
      this.hours = "07:00 - 22:00"});

  Market.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.logo =
        "https://app.daeem.ma/images/supermarkets/logos/" + json['logo'];
    this.cover =
        "https://app.daeem.ma/images/supermarkets/covers/" + json['cover'];
    this.phone = json['phone'];
    this.address = json['address'];
    this.cityId = json['city_id'];
    this.description = json['description'];
    this.lat = json['lat'];
    this.lng = json['lng'];
    this.isFakeRating = json['use_fake_rating'] == "0" ? false : true;
    this.status = json['status'] == "0" ? false : true;
    getHours(id??json['id']).then((value) {  hours=value;});
  }

 Future<String> getHours(int id) async {
    MarketService service = MarketService();
    Response? response = await service.getMarketsHours(id);
    if (response != null && response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] != "error") {
         data = data['data'];
        switch (DateFormat('EEEE').format(DateTime.now())) {
          case "Monday":
            return "${data['0_from']} - ${data['0_to']}";
          case "Tuesday":
            return "${data["1_from"]} - ${data["1_to"]}";
          case "Wednesday":
            return "${data['2_from']} - ${data['2_to']}";
          case "Thursday":
            return "${data['3_from']} - ${data['3_to']}";
          case "Friday":
            return "${data['4_from']} - ${data['4_to']}";
          case "Saturday":
            return "${data['5_from']} - ${data['5_to']}";
          case "Sunday":
            return "${data['6_from']} - ${data['6_to']}";
          default:
             return "07:00 - 22:00";
        }
      } else {
        return "07:00 - 22:00";
      }
    } else {
      return "07:00 - 22:00";
    }
  }
}