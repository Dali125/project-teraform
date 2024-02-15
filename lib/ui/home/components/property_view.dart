import 'package:flutter/material.dart';
import 'package:projectTeraform/ui/global_components/custom_button.dart';

class ViewProperty extends StatefulWidget {
  final String images;
  const ViewProperty({super.key, required this.images});

  @override
  State<ViewProperty> createState() => _ViewPropertyState();
}

class _ViewPropertyState extends State<ViewProperty> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomSheet: Material(
        elevation: 10,
        child: Container(
          height: size.height/8,
          width: size.width,

          child: Row(
            children: [
        
              CustomButton(onTap: (){}, height: 60, width: 140, buttonColor: Colors.orange, buttonText:
              const Text('Reserve', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),),)
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height /2.1,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.images,
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }
}
