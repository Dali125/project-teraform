import 'package:flutter/material.dart';

class ViewProperty extends StatefulWidget {
  final String images;
  const ViewProperty({super.key, required this.images});

  @override
  State<ViewProperty> createState() => _ViewPropertyState();
}

class _ViewPropertyState extends State<ViewProperty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              widget.images,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
