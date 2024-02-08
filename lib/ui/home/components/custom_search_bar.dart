import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final onTap;
  const CustomSearchBar({Key? key,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orange.shade100,
        ),

        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 20,),
              Text('Search')
            ],
          ),
        ),

      ),
    );
  }
}
