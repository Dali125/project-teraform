import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';


class MapView extends StatefulWidget {
  final Position current_location;
  const MapView({Key? key, required this.current_location}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  final _controller = Completer<GoogleMapController>();
  final markers = <MarkerId, Marker>{};

  late GoogleMapController mapController;
  late Position _currentPosition;
  late Geoflutterfire geo;
  late Stream<List<DocumentSnapshot>> stream;
  final radius = BehaviorSubject<double>.seeded(1.0);
  List<DocumentSnapshot> geoPoints = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
       _getGeoPointsFromFirestore();
    geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude: widget.current_location.latitude,
        longitude: widget.current_location.longitude);

    stream = radius.switchMap((rad) {
      final collectionReference = FirebaseFirestore.instance.collection(
          'posts');

      return geo.collection(collectionRef: collectionReference).within(center: center,
          radius: rad, field: 'property_location', strictMode: true);
    });
    setState(() {
      _currentPosition = widget.current_location;
    });

  }

  void dispose(){

    radius.close();
    super.dispose();
  }


  void _onMapCreated(GoogleMapController controller){
    setState(() {
      mapController = controller;

      stream.listen((List<DocumentSnapshot> docList) {
        _updateMarkers(docList);
      });
    });
  }



  void _updateMarkers(List<DocumentSnapshot> docList){
    docList.forEach((DocumentSnapshot documentSnapshot) {

      final data = documentSnapshot.data() as Map<String, dynamic>;
      final GeoPoint point = data['property_location']['geopoint'];
      _addMarker(point.latitude, point.longitude);
    });

  }

  void _addMarker(double lat, double long){
    final id = MarkerId(lat.toString()+long.toString());

    final _marker = Marker(markerId: id,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  double _value = 20;
  String _label = '';

  changed(value){
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
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


      :Stack(
        children: [
          LayoutBuilder(

            builder: (context, constraints) {

              return Container(
                height: constraints.maxHeight / 1.6,
                width: MediaQuery.of(context).size.width,
                child: Stack( children:[
                GoogleMap(

                    myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  fortyFiveDegreeImageryEnabled: true,
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  markers: Set<Marker>.of(markers.values),

                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        widget.current_location.latitude as double, widget.current_location.longitude as double),
                    zoom: 12,

                )),

                ]
              ),

                  );
            }
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slider(
              activeColor: Colors.blue,
                divisions: 4,
                max: 200,
                min: 1,
                inactiveColor: Colors.blue.withOpacity(0.2),
                label: _label,
                value: _value, onChanged: (value){
              changed(value);
            }),
          )
        ],
      )
    );
  }
}
