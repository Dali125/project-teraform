

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projectTeraform/ui/home/components/map_view.dart';

import '../search/page.dart';
import 'components/custom_search_bar.dart';

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
    });
  }

  String name = '';
  Future<void> getUserName() async{

    QuerySnapshot userdetails =
   await FirebaseFirestore.instance.collection('users').
   where('user_id', isEqualTo: myUid).get();

    userdetails.docs.forEach((element) {

      final firstName = element['first_name'];
      final lastName = element['last_name'];
      setState(() {
        name = firstName;

      });

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

        title: Text("Home"),
      ),

      body: Padding(
        padding:const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          controller: myScCon,
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(
                height: 25,
              ),





              Text('Nearby Places', style: Theme.of(context).textTheme.headlineMedium,),
              const SizedBox(
                height: 25,
              ),
              StreamBuilder(stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                  builder: (context, snapshot){


                if(snapshot.hasData){
                  return SizedBox(
                    height: size.height,
                    width: size.width,
                    child: ListView.separated(
                      controller: myScCon,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){

                          final data = snapshot.data!.docs[index];


                          return LocationPostTile();


                    }, separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 13,);
                    },),
                  );


                }
                else {
                  return const Column(
                  children: [

                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
                }







                  }),



            ],
          ),
        ),
      ),

      floatingActionButton: MyFab(onTap: (){
       
        log('I have been Tapped');
        Navigator.push(context, MaterialPageRoute(builder: (context) => MapView(

          current_location: _currentPosition
        )));
      },),


    );
  }
}
