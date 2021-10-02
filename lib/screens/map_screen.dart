import 'dart:async';

import 'package:daeem/provider/market_provider.dart';
import 'package:daeem/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

 late MarketProvider marketProvider ;


 
 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   marketProvider = Provider.of<MarketProvider>(context,listen: false);
       generateMarkers();
 }
  List<Marker> markers = List.empty(growable: true);

  generateMarkers(){
    Marker marker ;
    marketProvider.markets.forEach((element) {
      marker = Marker(markerId: MarkerId( element.id!.toString()),position: LatLng(double.parse(element.lat!), double.parse(element.lng!)));
      markers.add(marker);
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
              markers: markers.toSet(),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
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
                      }, icon: Icon(CupertinoIcons.location),iconSize: 30,color: Config.color_1,),
                ),
            ).align(alignment: Alignment.bottomRight).paddingOnly(bottom:120,right: 10),
          ],
        ),
      ),
     
    );
  }

 
}