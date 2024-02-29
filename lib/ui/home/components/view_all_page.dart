import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projectTeraform/ui/home/components/all_property_view.dart';
import 'package:projectTeraform/ui/search/components/search_n_filter/search_view.dart';

class ViewAllProperty extends StatefulWidget {
  final Position current_position;
  const ViewAllProperty({super.key, required this.current_position});

  @override
  State<ViewAllProperty> createState() => _ViewAllPropertyState();
}

class _ViewAllPropertyState extends State<ViewAllProperty> {
  late StreamController<List<DocumentSnapshot>> _streamController;
  double radius = 50;
  String field = 'position';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamController = StreamController<List<DocumentSnapshot>>.broadcast();
    _streamController.addStream(getNearbyPosts());
  }

  @override
  void dispose() async {
    super.dispose();

    await _streamController.close();
  }

  Stream<List<DocumentSnapshot>> getNearbyPosts() async* {
    GeoFirePoint center = GeoFirePoint(
        widget.current_position.latitude, widget.current_position.longitude);
    var collectionReference = FirebaseFirestore.instance.collection('posts');
    var radius = 75.0;
    var field = 'location-position';

    GeoFlutterFire geo = GeoFlutterFire();
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field, strictMode: true);

    yield* stream;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('All Property'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: size.width,
                  height: size.height / 1.55,
                  child: Container(
                      height: size.height,
                      width: size.width,
                      child: StreamBuilder(
                          key: ValueKey(DateTime.now()),
                          stream: _streamController.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: ((context, index) {
                                    final data = snapshot.data![index];

                                    return AllPropsView(data: data);
                                  }));
                            } else if (snapshot.hasError) {
                              return Icon(Icons.error_outline);
                            } else {
                              return CircularProgressIndicator();
                            }
                          })),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
