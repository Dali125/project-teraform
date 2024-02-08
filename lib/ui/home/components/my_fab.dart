import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class MyFab extends StatefulWidget {
  final onTap;
  const MyFab({Key? key, required this.onTap}) : super(key: key);

  @override
  State<MyFab> createState() => _MyFabState();
}

class _MyFabState extends State<MyFab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  double radius = 20;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));


    _scale = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(parent: _controller, curve: Curves.ease

    ))..addListener(() {
      setState(() {

      });
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: (){
          _controller.forward().
          whenComplete(() => _controller.reverse()
            ..whenComplete(widget.onTap));


        },
        onLongPress: (){
          _controller.forward();
        }
        ,
        onLongPressEnd: (details){
          _controller.reverse();
        },
        child: Transform.scale(
          scale: _scale.value,
        child:Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(radius),
          child: AnimatedContainer(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(radius)
            
                
          ),
          duration: Duration(milliseconds: 100),

            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.map),
                  Text(
                    'Show on Map'
                  )
                ],
              ),
            ),
              ),
        )),
      );
  }
}
