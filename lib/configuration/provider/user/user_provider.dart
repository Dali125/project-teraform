import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  late DocumentSnapshot _userData;

  DocumentSnapshot get userData => _userData;


  Future<void> fetchUserData(String userId) async{

    try{
      QuerySnapshot userDoc = await
          FirebaseFirestore.instance.collection('users')
          .where('user_id',isEqualTo: userId).limit(1).get();

      if(userDoc.docs.isNotEmpty){

        _userData = userDoc.docs.first;
        notifyListeners();
      }else{
        throw Exception('User Not Found');
      }



    }catch(e){
      log('Error getting user: $e');

    }
  }
}