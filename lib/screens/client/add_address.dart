
import 'dart:ui';

import 'package:daeem/models/address.dart';
import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:daeem/services/client_location.dart';
class AddressPage extends StatefulWidget {
  static const id = "add_address";

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late TextEditingController _street, _number, _business, _floor, _post;

  Position? _currentPosition;
  Marker? marker;
  GoogleMapController? _controller ;

  CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(35.7651929, -5.7999158), zoom: 11);

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<Placemark> address = [];
  late ClientProvider _clientProvider ;
  late AddressProvider _addressProvider;
  @override
  void initState() {
    _street = TextEditingController();
    _number = TextEditingController();
    _business = TextEditingController();
    _floor = TextEditingController();
    _post = TextEditingController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _clientProvider =  Provider.of<ClientProvider>(context,listen:false);
      _addressProvider    =   Provider.of<AddressProvider>(context,listen: false);
    });

    super.initState();
  }
 

  

  void getLocation() async {
    _currentPosition = await LocationService().getLoc();
    
    if (_currentPosition != null) {
      print("${_currentPosition!.latitude}" +"dd"+"${ _currentPosition!.latitude}");
      _kGooglePlex = CameraPosition(
        zoom: 20,
          target:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
       _controller?.animateCamera(CameraUpdate.newLatLng( LatLng(_currentPosition!.latitude, _currentPosition!.longitude)));
       address = await LocationService()
          .getAddress(_currentPosition!.latitude, _currentPosition!.longitude);
      _street.text = "${address.first.street??''}";
    _post.text = "${address.first.postalCode??''}";
    }
  }

  ScrollPhysics _physiques = BouncingScrollPhysics();

  @override
  void dispose() {
    _street.dispose();
    _number.dispose();
    _business.dispose();
    _floor.dispose();
    _post.dispose();
    _controller?.dispose();
    super.dispose();
  }
   _submit()async{
     var result = _formkey.currentState?.validate();
     if(result!=null&&result){
       Address _address = Address(streetName: _street.text,codePostal: _post.text,lat: "${_currentPosition?.latitude??''}",lng:"${_currentPosition?.longitude??''}", city: address.first.locality);
      _addressProvider.setAddress(_address);
       if(_clientProvider.client!=null)
       await _clientProvider.updateAddress(_address);
       Toast.show("Address was added with  success", context,duration: 4);
       Navigator.pushReplacementNamed(context,Home.id);
       
  

     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(physics: _physiques, slivers: [
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height * 0.6,
          elevation: 0,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            color: Colors.black,
            iconSize: 26,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          snap: true,
          floating: true,
          stretch: true,
          backgroundColor: Colors.grey.shade50,
          flexibleSpace: FlexibleSpaceBar(
            background: GoogleMap(
              onTap: (latLang) {
                setState(() {
                  _physiques = NeverScrollableScrollPhysics();
                });
              },
              onLongPress: (latLang) {
                setState(() {
                  _physiques = NeverScrollableScrollPhysics();
                });
              },
              initialCameraPosition: _kGooglePlex,
              compassEnabled: false,

              ///Todo:When published set to false
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller=controller;
              },
            ),
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(75),
              child: Transform.translate(
                offset: Offset(0, 1),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                      child: Container(
                    width: 50,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )),
                ),
              )),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          InkWell(
            onLongPress: () {
              setState(() {
                _physiques = BouncingScrollPhysics();
              });
            },
            onTap: () {
              setState(() {
                _physiques = BouncingScrollPhysics();
              });
            },
            child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          getLocation();
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Config.color_2.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Center(
                                child: Icon(
                                  Ionicons.navigate,
                                  size: 20,
                                  color: Config.color_1,
                                ).paddingOnly(right: 3, top: 3).center(),
                              ),
                            ).paddingOnly(right: 10),
                            Text(
                              "Use current location",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Config.color_1),
                            )
                          ],
                        ),
                      ).paddingOnly(
                        left: 10,
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TextFormField(
                                    controller: _street,
                                    validator: (value) {
                                      if (value == null || value == '') {
                                        return "Street name  is  required";
                                      }
                                      return null;
                                    },
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                        labelText: "Street name",
                                        labelStyle: GoogleFonts.ubuntu(
                                            fontSize: 18,
                                            color: Colors.grey.shade500),
                                        icon: Icon(
                                          CupertinoIcons.flag,
                                          color: Colors.black54,
                                          size: 28,
                                        ).paddingOnly(left: 15, right: 5),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none))
                                .paddingOnly(
                              right: 20,
                            ),
                            TextFormField(
                                    controller: _number,
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                        labelText: "Number",
                                        labelStyle: GoogleFonts.ubuntu(
                                            fontSize: 18,
                                            color: Colors.grey.shade500),
                                        icon: Icon(
                                          Ionicons.home_outline,
                                          color: Colors.black54,
                                          size: 28,
                                        ).paddingOnly(left: 15, right: 5),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none))
                                .paddingOnly(
                              right: 20,
                            ),
                            TextFormField(
                                    controller: _business,
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                        labelText: "Business / Building name",
                                        labelStyle: GoogleFonts.ubuntu(
                                            fontSize: 18,
                                            color: Colors.grey.shade500),
                                        icon: Icon(
                                          Ionicons.business_outline,
                                          color: Colors.black54,
                                          size: 28,
                                        ).paddingOnly(left: 15, right: 5),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none))
                                .paddingOnly(
                              right: 20,
                            ),
                            TextFormField(
                                    controller: _floor,
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                        labelText: "Floor / Door number",
                                        labelStyle: GoogleFonts.ubuntu(
                                            fontSize: 18,
                                            color: Colors.grey.shade500),
                                        icon: Icon(
                                          Icons.stairs_outlined,
                                          color: Colors.black54,
                                          size: 28,
                                        ).paddingOnly(left: 15, right: 5),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none))
                                .paddingOnly(
                              right: 20,
                            ),
                            TextFormField(
                                    controller: _post,
                                    validator: (value) {
                                      return null;
                                    },
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                        labelText: "Post code",
                                        labelStyle: GoogleFonts.ubuntu(
                                            fontSize: 18,
                                            color: Colors.grey.shade500),
                                        icon: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.black54,
                                          size: 28,
                                        ).paddingOnly(left: 15, right: 5),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none))
                                .paddingOnly(
                              right: 20,
                            ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          _submit();
                        },
                        height: 50,
                        elevation: 0,
                        splashColor: Config.color_1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Config.color_2,
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ])),
      ]),
    );
  }
}
