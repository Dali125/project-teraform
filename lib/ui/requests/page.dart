import 'package:flutter/material.dart';
import 'package:projectTeraform/ui/requests/components/accepted.dart';
import 'package:projectTeraform/ui/requests/components/pending.dart';

class RequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Requests and Reservations',
            style: TextStyle(color: Colors.orange),
          ),
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.pending),
              text: "Pending Reservations",
            ),
            Tab(
              icon: Icon(Icons.done),
              text: "Accepted Reservations",
            ),
          ]),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: TabBarView(
            children: [PendingReservations(), AcceptedReservations()],
          ),
        ),
      ),
    );
  }
}
