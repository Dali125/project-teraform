import 'package:flutter/material.dart';

class LocationPostTile extends StatefulWidget {
  const LocationPostTile({Key? key}) : super(key: key);

  @override
  State<LocationPostTile> createState() => _LocationPostTileState();
}

class _LocationPostTileState extends State<LocationPostTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height/3.5,

      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),

      child: Stack(
        children: [


          Container(
            decoration: const BoxDecoration(
                color: Colors.orange,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),
                  topRight: Radius.circular(10))
            ),
            width: size.width,
            height: size.height /5,

          ),
          const Positioned(
              top: 20,
              right: 20,
              child: Icon(Icons.favorite, size: 30,)),
        ],
      ),
    );
  }
}
