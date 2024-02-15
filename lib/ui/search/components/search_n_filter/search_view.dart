import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> data;
  const SearchView({Key? key, required this.data}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 1.7,
      width: size.width,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height / 2.4,
              width: size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(30),
                    topRight: Radius.circular(30) , bottomLeft:Radius.circular(30), bottomRight: Radius.circular(30) ),
                color: Colors.orange,


              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(widget.data['images'][0], fit: BoxFit.cover,)),
            ),

            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                Text(widget.data['location'], style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16

                )
                  ,)
              ],
            ),
            SizedBox(
              height: 7,
            ),
            Text('Hosted By Dalitso Ngulube', style: const TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 14

            ),),
            SizedBox(
              height: 7,
            ),
            Row(
              children: [
                Text('K ${widget.data['fees']}', style: const TextStyle(
                  fontWeight: FontWeight.bold,
                    fontSize: 16
                ),), Text(' total before taxes')
              ],
            )
          ],
        ),
      ),


    );
  }
}
