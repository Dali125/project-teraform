import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/search_n_filter.dart';
import 'components/search_n_filter/boarding_house_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: [
                const SearchAndFilter(),
                const TabBar(
                    labelColor: Colors.orange,
                    indicatorColor: Colors.orange,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.directions_car),
                        text: "Boarding House",
                      ),
                      Tab(
                        icon: Icon(Icons.home_filled),
                        text: "House",
                      ),
                    ]),
                const SizedBox(
                  height: 12,
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    width: size.width,
                    height: size.height / 1.55,
                    child: const TabBarView(
                      children: [
                        BoardingHouseView(),
                        Icon(Icons.directions_transit),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
