import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

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
  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  late TextEditingController _latitudeController, _longitudeController;

  // firestore init
  final _firestore = FirebaseFirestore.instance;
  late GeoFlutterFire geo;
  late Stream<List<DocumentSnapshot>> stream;
  final radius = BehaviorSubject<double>.seeded(1.0);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    geo = GeoFlutterFire();
    GeoFirePoint center = geo.point(latitude: 12.960632, longitude: 77.641603);
    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection('posts');
//          .where('name', isEqualTo: 'darshan');
      return geo.collection(collectionRef: collectionReference).within(
          center: center,
          radius: rad,
          field: 'location-position',
          strictMode: true);

      /*
      ****Example to specify nested object****

      var collectionReference = _firestore.collection('nestedLocations');
//          .where('name', isEqualTo: 'darshan');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'address.location.position');

      */
    });
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    radius.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50))),
                      width: mediaQuery.size.width,
                      height: mediaQuery.size.height / 1.5,
                      child: GoogleMap(
                        compassEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(widget.current_location.latitude,
                              widget.current_location.longitude),
                          zoom: 15.0,
                        ),
                        markers: Set<Marker>.of(markers.values),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 40,
                      left: 10,
                      child: Center(
                        child: Container(
                          height: 52,
                          width: 54,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(30)),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.arrow_back_ios)),
                        ),
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 12),
                child: Text(
                  "Drag the Slider to expand your Search",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Current Radius $_value"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Slider(
                  min: 1,
                  max: 10000,
                  divisions: 4,
                  value: _value,
                  label: _label,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.blue.withOpacity(0.2),
                  onChanged: (double value) => changed(value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController.complete(controller);

      //start listening after map is created
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      });
    });
  }

  void _showHome() async {
    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(widget.current_location.latitude,
            widget.current_location.longitude),
        zoom: 15.0,
      ),
    ));
  }

  void _addPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore.collection('posts').add({
      'name': 'random name',
      'location-position': geoFirePoint.data
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  //example to add geoFirePoint inside nested object
  void _addNestedPoint(double lat, double lng) {
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    _firestore.collection('nestedLocations').add({
      'name': 'random name',
      'address': {
        'location': {'position': geoFirePoint.data}
      }
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  void _addMarker(double lat, double lng) {
    final id = MarkerId(lat.toString() + lng.toString());
    final _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'latLng', snippet: '$lat,$lng'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      Map<String, dynamic> snapData = document.data() as Map<String, dynamic>;
      final GeoPoint point = snapData['location-position']['geopoint'];
      _addMarker(point.latitude, point.longitude);
    });
  }

  double _value = 20.0;
  String _label = '';

  changed(value) {
    setState(() {
      _value = value;
      _label = '${{_value.toInt() / 1000}.toString()} kms';
      markers.clear();
    });
    radius.add(value);
  }
}
