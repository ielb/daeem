import 'dart:async';
import 'dart:ui';
import 'package:daeem/models/address.dart';
import 'package:daeem/provider/address_provider.dart';
import 'package:daeem/provider/client_provider.dart';
import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:daeem/services/client_location.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AddressPage extends StatefulWidget {
  static const id = "add_address";

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late TextEditingController _street, _number, _business, _floor, _post;

  Position? _currentPosition;
  Marker? marker;
  GoogleMapController? _controller;

  CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(35.7651929, -5.7999158), zoom: 11);
  Set<Marker> _markers = {};
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<ExpandableBottomSheetState> key = new GlobalKey();
  String? fromRoute;
  List<Placemark> address = [];
  late ClientProvider _clientProvider;
  late AddressProvider _addressProvider;
  late StoreProvider _storeProvider;
  late BitmapDescriptor icon;
  late LatLng? markerPosition;
  bool isVisible = false;

  @override
  void initState() {
    _street = TextEditingController();
    _number = TextEditingController();
    _business = TextEditingController();
    _floor = TextEditingController();
    _post = TextEditingController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
              devicePixelRatio: screenSize(context).aspectRatio,
              size: Size(1, 1)),
          "assets/pin.png");
      _clientProvider = Provider.of<ClientProvider>(context, listen: false);
      _storeProvider = Provider.of<StoreProvider>(context, listen: false);
      _addressProvider = Provider.of<AddressProvider>(context, listen: false);
      getLocation();

      fromRoute = ModalRoute.of(context)?.settings.arguments as String?;
    });

    super.initState();
  }

  void getLocation() async {
    showDialog(
        context: context,
        builder: (context) => CircularProgressIndicator().center());
    _currentPosition = await LocationService().getLoc().catchError((error) {
      print(error);
    });

    if (_currentPosition != null) {
      _kGooglePlex = CameraPosition(
          zoom: 20,
          target:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude));
      _controller!.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          18));
      address = await LocationService()
          .getAddress(_currentPosition!.latitude, _currentPosition!.longitude);
      _street.text = "${address.first.street ?? ''}";
      _post.text = "${address.first.postalCode ?? ''}";
      _markers.add(Marker(
          markerId: MarkerId('marker_2'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.latitude),
          draggable: true,
          icon: icon,
          infoWindow: InfoWindow(title: "test")));
      Navigator.pop(context);
    }
    Timer(Duration(milliseconds:2500), () {
     if(mounted)
       expand();
    });
    

  }

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

  _submit() async {
    showDialog(
        context: context,
        builder: (context) => CircularProgressIndicator().center());
    var result = _formkey.currentState?.validate();
    if (result != null && result) {
      Address _address = Address(
          address: _number.text.isEmpty
              ? _street.text
              : _street.text + " Nº" + _number.text,
          clientId: _clientProvider.client?.id,
          streetName: _street.text,
          codePostal: _post.text,
          lat: "${_currentPosition?.latitude ?? ''}",
          lng: "${_currentPosition?.longitude ?? ''}",
          city: address.first.locality);

      if (_clientProvider.client != null) {
        print(_address.clientId);
        _addressProvider.setAddress(_address);
        _clientProvider.setClientAddress(_address);
        await _clientProvider.updateAddress(_address);
        await _storeProvider.getStoreType();
        await _storeProvider.getStores(_address);
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "Address added with success",
          ),
        );
      } else {
        await _storeProvider.getStoreType();
        await _storeProvider.getStores(_address);
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            message: "For better experience sign in",
          ),
        );
        _addressProvider.setAddress(_address);
      }
      Navigator.pop(context);

      if (fromRoute == null)
        Navigator.pushReplacementNamed(context, Home.id);
      else
        Navigator.pop(context);
    }
  }

  void _updatePosition(CameraPosition _position) {
    _markers.clear();
    _markers.add(
      Marker(
          markerId: MarkerId('marker_2'),
          position:
              LatLng(_position.target.latitude, _position.target.longitude),
          icon: icon),
    );
    setState(() {
      markerPosition =
          LatLng(_position.target.latitude, _position.target.longitude);
    });
  }

  getPostion() async {
    if (markerPosition != null) {
      address.clear();
      address = await LocationService()
          .getAddress(markerPosition!.latitude, markerPosition!.longitude);
      if (address.first.street != null &&
          address.first.street != 'Unnamed Road') {
        _street.text =
            "${address.first.street!}   ${address.first.subLocality ?? ''}";
        _post.text = "${address.first.postalCode ?? ''}";

        expand();
      } else {
        if(mounted) {
          showTopSnackBar(context,
            CustomSnackBar.info(message: "Please select a valid address"));
        }
      }
    }
  }

  void expand() => key.currentState!.expand();

  void contract() => key.currentState!.contract();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  ExpandableBottomSheet(
            key: key,
            enableToggle: true,
            background: Stack(
              children: [
                Listener(
                  onPointerMove: (PointerMoveEvent event) {
                    setState(() {
                      isVisible = false;
                    });
                  },

                  onPointerUp: (event) {
                    setState(() {
                      isVisible = true;
                    });
                  },
                  child: GoogleMap(
                    initialCameraPosition: _kGooglePlex,
                    compassEnabled: false,
                    markers: _markers,
                    zoomControlsEnabled: false,
                    onCameraMove: ((_position) => _updatePosition(_position)),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: screenSize(context).height * 0.4,
                  child: Visibility(
                    visible: isVisible,
                    child: Center(
                      child: Container(
                        height: 85,
                        width: screenSize(context).width * .75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade50,
                              spreadRadius: 2,
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text("Place the pin exacly on your door",
                                    style: GoogleFonts.ubuntu(fontSize: 18))
                                .paddingOnly(top: 15),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                getPostion();
                              },
                              child: Text("Use this position  >",
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 16, color: Config.color_2)),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  left: 5,
                  child: IconButton(
                    icon: Icon(CupertinoIcons.back),
                    color: Colors.black,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
            persistentHeader: Transform.translate(
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
            ),
            persistentContentHeight: 70,
            expandableContent: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      ).paddingOnly(left: 10, bottom: 20),
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
                                .paddingOnly(right: 20, bottom: 20),
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
                ))));
  }
}
