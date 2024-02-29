import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectTeraform/ui/search/components/search_n_filter/search_view.dart';

class BoardingHouseView extends StatefulWidget {
  const BoardingHouseView({Key? key}) : super(key: key);

  @override
  State<BoardingHouseView> createState() => _BoardingHouseViewState();
}

class _BoardingHouseViewState extends State<BoardingHouseView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .where('property_type', isEqualTo: 'House')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    final QueryDocumentSnapshot<Map<String, dynamic>> data =
                        snapshot.data!.docs[index];
                    return SearchView(data: data);
                  },
                  separatorBuilder: (context, int) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: snapshot.data!.docs.length);
            } else if (snapshot.hasError) {
              return Icon(Icons.error_outline);
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
