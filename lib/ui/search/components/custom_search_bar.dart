import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final onTap;
  const CustomSearchBar({Key? key,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  InkWell(



      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size.width/1.48,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white

          ),
      
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 20,),
                Text('Where to?')
              ],
            ),
          ),
      
        ),
      ),
    );
  }
}
