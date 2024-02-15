import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectTeraform/configuration/provider/user/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget  {
  const ProfilePage({Key? key}) : super(key: key);







  @override
  Widget build(BuildContext context) {

    final userProvider =
        Provider.of<UserProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: Text(
          'My Profile'
        ),
      ),
      body: userProvider.userData == null? CircularProgressIndicator(): SafeArea(child: Center(child: Text(userProvider.userData['user_id']),)),

    );
  }
}
