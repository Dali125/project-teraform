import 'package:flutter/material.dart';

class ExpandedSearch extends StatefulWidget {
  const ExpandedSearch({Key? key}) : super(key: key);

  @override
  State<ExpandedSearch> createState() => _ExpandedSearchState();
}

class _ExpandedSearchState extends State<ExpandedSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(



      body: Column(

        children: [


          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 5,
              child: Container(
                height: 400,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  
                ),
                
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text("Where to ?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
