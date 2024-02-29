import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectTeraform/ui/profile/page.dart';
import 'package:projectTeraform/ui/requests/page.dart';
import 'package:projectTeraform/ui/search/page.dart';
import 'package:provider/provider.dart';

import '../../configuration/provider/user/user_provider.dart';
import '../home/page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _controller = Completer<GoogleMapController>();

  int currentIndex = 0;

  final tabs = <Widget>[
    const HomePage(),
    const SearchPage(),
    const Placeholder(),
    RequestsPage(),
    ProfilePage()
  ];

  final items = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: 'Home'),
    const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.favorite), label: 'Favorites'),
    const BottomNavigationBarItem(
        icon: Icon(Icons.file_copy), label: 'Favorites'),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile')
  ];
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    final userProvider = Provider.of<UserProvider>(context);
    final userdata = userProvider.fetchUserData(userId);
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.black,
        items: items,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
            print(currentIndex);
          });
        },
      ),
    );
  }
}
