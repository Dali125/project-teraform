import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectTeraform/ui/auth/login/page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('user_id',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final data = snapshot.data!.docs[0];
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: size.height,
                      width: size.width,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange,
                                      Colors.orangeAccent
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40))),
                              child: Column(children: [
                                const SizedBox(
                                  height: 110.0,
                                ),
                                const CircleAvatar(
                                  radius: 65.0,
                                  backgroundImage:
                                      AssetImage('assets/erza.jpg'),
                                  backgroundColor: Colors.white,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                    '${data['first_name']} ${data['last_name']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    )),
                                const SizedBox(
                                  height: 10.0,
                                ),
                              ]),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit Information'),
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.phone),
                                  title: Text('Contact us'),
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.share),
                                  title: Text('Share app with Others'),
                                ),
                                Divider(),
                                ListTile(
                                  onTap: () async {
                                    await FirebaseAuth.instance
                                        .signOut()
                                        .whenComplete(() =>
                                            //Use this for logout

                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        LoginPage()),
                                                (Route<dynamic> route) =>
                                                    false));
                                  },
                                  leading: Icon(Icons.logout),
                                  title: Text('Logout'),
                                ),
                                Divider()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
