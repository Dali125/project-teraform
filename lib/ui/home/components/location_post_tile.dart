import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectTeraform/ui/home/components/property_view.dart';
import 'package:shimmer/shimmer.dart';

class LocationPostTile extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snapshotData;
  final List<dynamic> images;
  final String status;
  final String price;
  final String bedrooms;
  final String location;
  const LocationPostTile(
      {Key? key,
      required this.snapshotData,
      required this.images,
      required this.status,
      required this.price,
      required this.bedrooms,
      required this.location})
      : super(key: key);

  @override
  State<LocationPostTile> createState() => _LocationPostTileState();
}

class _LocationPostTileState extends State<LocationPostTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return OpenContainer(closedBuilder: (context, VoidCallback openContainer) {
      return Card(
        elevation: 3,
        child: Container(
          width: size.width / 1.5,
          height: size.height / 4.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: size.height / 3.5,
                width: size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.red,
                ),
                child: Image.network(
                  widget.images[0],
                  fit: BoxFit.cover,
                  // loadingBuilder: (context, child, loadingProgress) {
                  //   log('${loadingProgress.toString()}');
                  //   return Shimmer(
                  //       gradient: LinearGradient(
                  //           colors: [Colors.grey.shade100, Colors.grey]),
                  //       child: Container(
                  //         height: size.height / 3.3,
                  //         width: size.width,
                  //         decoration: const BoxDecoration(
                  //           borderRadius: BorderRadius.only(
                  //               topLeft: Radius.circular(10),
                  //               topRight: Radius.circular(10)),
                  //           color: Colors.orangeAccent,
                  //         ),
                  //       ));
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.status),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.location,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.bedrooms} Bedroomss',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'k${widget.price}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }, openBuilder: (context, VoidCallback _) {
      return ViewProperty(
          snapshotData: widget.snapshotData, images: widget.images);
    });
  }
}
