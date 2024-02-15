import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projectTeraform/ui/home/components/map_view.dart';
import 'package:shimmer/shimmer.dart';

import '../search/page.dart';
import '../search/components/custom_search_bar.dart';

import 'components/location_post_tile.dart';
import 'components/my_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myScCon = ScrollController();

  late Position _currentPosition;
  final myUid = FirebaseAuth.instance.currentUser!.uid.toString();
  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      locationFound = true;
    });
  }

  bool locationFound = false;
  String name = '';
  Future<void> getUserName() async {
    QuerySnapshot userdetails = await FirebaseFirestore.instance
        .collection('users')
        .where('user_id', isEqualTo: myUid)
        .get();

    userdetails.docs.forEach((element) {
      final firstName = element['first_name'];
      final lastName = element['last_name'];
      setState(() {
        name = firstName;
      });
    });
  }

  void _addPoint(double lat, double lng) {
    final GeoFlutterFire geo = GeoFlutterFire();
    GeoFirePoint geoFirePoint = geo.point(latitude: lat, longitude: lng);
    FirebaseFirestore.instance.collection('posts').add({
      'name': 'random name',
      'location-position': geoFirePoint.data
    }).then((_) {
      print('added ${geoFirePoint.hash} successfully');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Project Teraform',
          style: TextStyle(
              color: Colors.orange, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 22),
          child: SingleChildScrollView(
            controller: myScCon,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Nearby Locations',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Text(
                                  'View All',
                                  style: TextStyle(color: Colors.blue),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: size.height / 2.4,
                              width: size.width,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                controller: myScCon,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final data = snapshot.data!.docs[index];

                                  return LocationPostTile(
                                    images: data['images'][0],
                                    status: data['property_status'],
                                    price: data['fees'],
                                    bedrooms: data['bedrooms'],
                                    location: data['location'],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    width: 13,
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Column(
                          children: [
                            Center(
                              child: CircularProgressIndicator(),
                            )
                          ],
                        );
                      }
                    }),
                SizedBox(
                  height: 60,
                ),
                Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height / 5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                            Colors.green.shade200,
                            Colors.green.shade400
                          ])),
                    ),
                    Positioned(
                        left: 20,
                        top: 60,
                        child: Text(
                          'Featured Properties',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: locationFound == true
          ? MyFab(
              onTap: () {
                log('I have been Tapped');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MapView(current_location: _currentPosition)));
              },
            )
          : Shimmer(
              direction: ShimmerDirection.ltr,
              enabled: true,
              gradient:
                  LinearGradient(colors: [Colors.grey.shade100, Colors.grey]),
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}
