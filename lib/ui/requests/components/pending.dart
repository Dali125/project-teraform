import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projectTeraform/utils.dart';

class PendingReservations extends StatefulWidget {
  const PendingReservations({super.key});

  @override
  State<PendingReservations> createState() => _PendingReservationsState();
}

class _PendingReservationsState extends State<PendingReservations> {
  Future<String> getName(String userId) async {
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('users');
      QuerySnapshot snapshot =
          await ref.where('user_id', isEqualTo: userId).get();

      if (snapshot.docs.isNotEmpty) {
        String firstName = snapshot.docs[0].get('first_name');
        String lastName = snapshot.docs[0].get('last_name');
        return '$firstName $lastName';
      } else {
        return ''; // Or you can throw an exception to indicate that the user was not found
      }
    } catch (error) {
      print('Error getting user name: $error');
      return ''; // Handle the error gracefully, you might want to throw an exception here
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('submitor_id',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final notificationsData = snapshot.data!.docs[index];
                return FutureBuilder<String>(
                  future: getName(notificationsData['owner_id']),
                  builder: (context, nameSnapshot) {
                    if (nameSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ListTile(
                        title: Text('Loading...'),
                      );
                    } else if (nameSnapshot.hasError) {
                      return ListTile(
                        title: Text('Error loading name'),
                      );
                    } else {
                      Timestamp sessionDate =
                          notificationsData['time'] as Timestamp;
                      return ListTile(
                        title: Text(
                          "Reservation to ${nameSnapshot.data}'s Property",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text('Status: Pending'),
                        trailing: Text(
                            'Submitted on ${sessionDate.toDate().day.toString()}/${sessionDate.toDate().month.toString()}/${sessionDate.toDate().year.toString()}'),
                      );
                    }
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }
}
