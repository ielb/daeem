import 'dart:async';

import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const id = "map";
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.7651929,-5.7999158),
  );




  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
     

   
    }).catchError((e) {
      print(e);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
      body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              ///Todo:When published set to false
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
            ),
            Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(CupertinoIcons.back),iconSize: 30,),
                SearchInput(TextEditingController(), "Search", 300, CupertinoIcons.search)
              ],
            ).paddingOnly(top:20,left: 10),
            Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:BorderRadius.circular(15), 
                ),
                child: Center(
                  child: IconButton(onPressed: (){
                       _getCurrentLocation();
                      }, icon: Icon(CupertinoIcons.location),iconSize: 30,color: Config.color_1,),
                ),
            ).align(alignment: Alignment.bottomRight).paddingOnly(bottom:120,right: 10),
          ],
        ),
      ),
     
    );
  }

 
}