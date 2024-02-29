import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dottedcarasoulslider/dottedcarasoulslider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectTeraform/ui/global_components/custom_button.dart';
import 'package:projectTeraform/ui/home/cubit/property_cubit.dart';
import 'package:projectTeraform/ui/root/root_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewProperty extends StatefulWidget {
  final List<dynamic> images;
  final snapshotData;
  const ViewProperty(
      {super.key, required this.images, required this.snapshotData});

  @override
  State<ViewProperty> createState() => _ViewPropertyState();
}

class _ViewPropertyState extends State<ViewProperty> {
  Map<String, dynamic> _userData = {};
  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the collection where user documents are stored
      CollectionReference usersCollection = firestore.collection('users');

      // Query for the user document that contains the provided userID
      QuerySnapshot userQuerySnapshot = await usersCollection
          .where('user_id', isEqualTo: widget.snapshotData['ownerID'])
          .get();

      // Check if any documents were found
      if (userQuerySnapshot.docs.isNotEmpty) {
        // Extract user data from the first document found (assuming userID is unique)
        Map<String, dynamic> userData =
            userQuerySnapshot.docs.first.data() as Map<String, dynamic>;
        return userData;
      } else {
        // User document with the provided userID not found
        return {"status": "user not found"};
      }
    } catch (e) {
      print('Error retrieving user details: $e');
      return {"status": e};
    }
  }

  List<String> images = [];
  void convertToString() {
    for (String image in widget.images) {
      setState(() {
        images.add(image);
      });
    }
  }

  void _showFullDescriptionModal(String text) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.3,
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        );
      },
    );
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    convertToString();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      isLoading == true;
    });

    Map<String, dynamic>? userData = await getUserDetails();
    if (userData != null) {
      setState(() {
        _userData = userData;
        isLoading = false;
      });
    } else {
      isLoading = false;
      // Handle error or display appropriate message
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => PropertyCubit(),
      child: BlocBuilder<PropertyCubit, PropertyState>(
        builder: (context, state) {
          return Scaffold(
              bottomSheet: Material(
                elevation: 10,
                child: Container(
                  height: size.height / 8,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'K ${widget.snapshotData['fees']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Text('Total Before Taxes'),
                          ],
                        ),
                        CustomButton(
                          onTap: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Confirm Reservation'),
                                    content: Text(
                                        'Your reservation will be sent to the property owner.'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            await context
                                                .read<PropertyCubit>()
                                                .submitRequest(widget
                                                    .snapshotData['ownerID'])
                                                .whenComplete(() {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RootPage()),
                                                  (route) => false);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'Submission Successful')));
                                            });
                                            print(state.status);
                                            if (state.message ==
                                                'Submission Successful') {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Submission Successful'),
                                                      content: Center(
                                                        child:
                                                            Icon(Icons.check),
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                          child: Text('Confirm')),
                                    ],
                                  );
                                });
                          },
                          height: 60,
                          width: 140,
                          buttonColor: Colors.orange,
                          buttonText: const Text(
                            'Reserve',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              body: isLoading == false
                  ? SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Stack(
                            children: [
                              Container(
                                height: size.height / 2.3,
                                width: MediaQuery.of(context).size.width,
                                child: DottedCarasoulSlider(
                                  showDots: true,
                                  autoplay: false,
                                  reverse: false,
                                  fit: BoxFit.cover,
                                  dotDirectionBottom: 0,
                                  dotDirectionLeft: 0,
                                  dotDirectionRight: 0,
                                  dotDirectionTop: 0,
                                  dotActiveColor: Colors.black,
                                  dotInActiveColor: Colors.orange,
                                  iconColor: Colors.blue,
                                  iconSize: 50,
                                  imgUrls: images,
                                  duration: const Duration(seconds: 3),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  aspectRatio: 1.2,
                                ),
                              ),
                              Positioned(
                                  top: 50,
                                  left: 20,
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.arrow_back)),
                                  ))
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: Text(
                              '${widget.snapshotData['property_type']}  ${widget.snapshotData['property_status']}',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: Text(
                              '${widget.snapshotData['house_summary']} in ${widget.snapshotData['location']}',
                              style: const TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12),
                            child: Text(
                              '${widget.snapshotData['bedrooms']} bedrooms, ${widget.snapshotData['beds']} beds, ${widget.snapshotData['bathrooms']} bathrooms',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0, right: 12),
                            child: Text(
                              'Property Description',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Divider(),
                          ),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18),
                            child: Text(
                              widget.snapshotData['description'],
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          InkWell(
                              onTap: () => _showFullDescriptionModal(
                                  widget.snapshotData['description']),
                              child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'View More ▼',
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ])),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Posted By:',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        isLoading == false
                                            ? Row(
                                                children: [
                                                  Text(
                                                    _userData['first_name'] ==
                                                            null
                                                        ? ''
                                                        : _userData[
                                                            'first_name'],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    _userData['last_name'] ==
                                                            null
                                                        ? ''
                                                        : _userData[
                                                            'last_name'],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              )
                                            : const CircularProgressIndicator(),
                                      ]),
                                  CustomButton(
                                    onTap: () {
                                      HapticFeedback.vibrate();
                                    },
                                    height: 60,
                                    width: 150,
                                    buttonText: const Text('Contact'),
                                    buttonColor: Colors.orange.shade600,
                                  )
                                ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 12.0, right: 12),
                            child: Text(
                              'Property Location',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: _openGoogleMaps,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 12.0, right: 12),
                              child: Container(
                                height: size.height / 4,
                                width: size.width,
                                decoration: BoxDecoration(border: Border.all()),
                                child: const Center(
                                  child: Text('Click here to get Directions'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 300,
                          )
                        ]))
                  : const CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> _openGoogleMaps() async {
    GeoPoint point = widget.snapshotData['location-position']['geopoint'];
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${point.latitude},${point.longitude}';
    if (await canLaunchUrl(Uri.parse(url)) == true) {
      log('yess');
      await launchUrl(Uri.parse(url));
    } else {
      _showMapLaunchErrorDialog();
    }
  }

  //When opening of map fails
  Future<void> _showMapLaunchErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Failed to open Google Maps.'),
                Text('Please check your internet connection and try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
