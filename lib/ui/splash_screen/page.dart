import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';

import '../auth/auth_check.dart';
import '../home/page.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SecondPage()

      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //
      //       SecondPage()
      //       // Text(
      //       //   'Suppose this is an app in your Ph_a\'s Screen page.',
      //       //   textAlign: TextAlign.center,
      //       //   style: TextStyle(
      //       //     fontSize: 17,
      //       //     fontWeight: FontWeight.bold,
      //       //   ),
      //       // ),
      //       // OpenContainer(
      //       //   closedBuilder: (_, openContainer) {
      //       //     return Container(
      //       //       height: 80,
      //       //       width: 80,
      //       //       child: Center(
      //       //         child: Text(
      //       //           'App Logo',
      //       //           style: TextStyle(
      //       //             fontWeight: FontWeight.bold,
      //       //           ),
      //       //         ),
      //       //       ),
      //       //     );
      //       //   },
      //       //   openColor: Colors.white,
      //       //   closedElevation: 20,
      //       //   closedShape: RoundedRectangleBorder(
      //       //       borderRadius: BorderRadius.circular(20)),
      //       //   transitionDuration: Duration(milliseconds: 700),
      //       //   openBuilder: (_, closeContainer) {
      //       //     return SecondPage();
      //       //   },
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool _a = false;
  bool _b = false;
  bool _c = false;
  bool _d = false;
  bool _e = false;
  bool _f = false;
  bool _g = false;
  bool _h = true;

  final TextStyle initialStyle = const TextStyle(
    fontSize: 30,
    color: Colors.orange,
    fontWeight: FontWeight.w600,
    wordSpacing: 2,
  );

  final TextStyle finalStyle = const TextStyle(
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.w600,
    wordSpacing: 2,
  );

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _g = true;
        _a = true;
        _h = !_h;
      });
    });
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _b = true;
        _h = !_h;
      });
    });
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _c = true;
        _h = !_h;
      });
    });
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _d = true;
        _h = !_h;
      });
    });
    Timer(const Duration(milliseconds: 2500), () {
      setState(() {
        _e = true;
        _h = !_h;
      });
    });
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _f = true;
        _h = !_h;
        _g = false;
      });
    });
    Timer(const Duration(milliseconds: 4000), () {
      Navigator.of(context).pushReplacement(
        ThisIsFadeRoute(
          route: const AuthenticationFlowScreen(), page: const HomePage(),

        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _a ? _height : 0,
              width: _a ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(_a ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _b ? _height : 0,
              width: _b ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_b ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _c ? _height : 0,
              width: _c ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(_c ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _d ? _height : 0,
              width: _d ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_d ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _e ? _height : 0,
              width: _e ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(_e ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 2200),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _f ? _height : 0,
              width: _f ? _width : 0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_f ? 0 : 99),
              ),
            ),
          ),
          Center(
            child: _g
                ? AnimatedDefaultTextStyle(
              style: _h ? initialStyle : finalStyle,
              duration: const Duration(seconds: 2),
              curve: Curves.fastLinearToSlowEaseIn,
              child: const Text("Project Teraform"),
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  Widget page;
  Widget? route;

  ThisIsFadeRoute({required this.page, this.route})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: route,
        ),
  );
}

