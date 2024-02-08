import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapView extends StatefulWidget {
  final Position current_location;
  const MapView({Key? key, required this.current_location}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  final _controller = Completer<GoogleMapController>();

  late GoogleMapController mapController;
  late Position _currentPosition;
  List<DocumentSnapshot> geoPoints = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
    _getGeoPointsFromFirestore();

    setState(() {
      _currentPosition = widget.current_location;
    });

  }
  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  void _getGeoPointsFromFirestore() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('posts').get();
    setState(() {
      geoPoints = snapshot.docs;
    });
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    for (var geoPoint in geoPoints) {
      double latitude = geoPoint['property_location'][0];
      double longitude = geoPoint['property_location'][1];
      String name = '$latitude$longitude';

      double distanceInMeters = Geolocator.distanceBetween(_currentPosition.latitude,
          _currentPosition.longitude,
          latitude,
          longitude);

      markers.add(Marker(
        markerId: MarkerId(name),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: name, snippet: 'Distance: $distanceInMeters m'),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }

    markers.sort((a, b) => _compareDistances(a, b));

    return markers;
  }

  int _compareDistances(Marker a, Marker b) {
    double distanceA = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        a.position.latitude,
        a.position.longitude);
    double distanceB = Geolocator.distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        b.position.latitude,
        b.position.longitude);
    return distanceA.compareTo(distanceB);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: _currentPosition == null ?
          Container(
             height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),

          )


      :Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack( children:[
        GoogleMap(

            myLocationEnabled: true,
          myLocationButtonEnabled: false,
          fortyFiveDegreeImageryEnabled: true,
          compassEnabled: false,
          zoomControlsEnabled: false,
          markers: Set<Marker>.of(_buildMarkers()),

          onMapCreated: (controller){
            _controller.complete(controller);
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(
                widget.current_location.latitude as double, widget.current_location.longitude as double),
            zoom: 12,

        )),

        ]
      ),

    )
    );
  }
}
