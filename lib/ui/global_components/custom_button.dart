import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final onTap;
  final double height;
  final double width;
  final buttonText;
  final buttonColor;
  const CustomButton({Key? key, required this.onTap, required this.height, required this.width, this.buttonText, this.buttonColor}) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  double radius = 10;

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


          _controller.forward().whenComplete(widget.onTap)
            .whenComplete(() => _controller.reverse());

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
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                    color: widget.buttonColor,
                    borderRadius: BorderRadius.circular(radius)


                ),
                duration: const Duration(milliseconds: 100),

                child: Center(
                  child: widget.buttonText,
                ),
              ),
            )),
      );
  }
}
