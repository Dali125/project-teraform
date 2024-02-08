import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:projectTeraform/ui/splash_screen/page.dart';



import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request location permissions
  await requestLocationPermission();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login UI with fadeOut animation',
      home: MyWidget(),
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
}


Future<void> requestLocationPermission() async {
  // Request permission
  PermissionStatus status = await Permission.location.request();

  // Handle the permission status
  if (status.isGranted) {
    print('Location permission is granted.');
  } else if (status.isDenied) {
    print('Location permission is denied.');
  } else if (status.isPermanentlyDenied) {
    print('Location permission is permanently denied. Redirecting to app settings...');
    openAppSettings(); // Redirect the user to the app settings
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _opacity;
//   late Animation<double> _transform;
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   @override
//   void initState() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2),
//     );
//
//     _opacity = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.ease,
//       ),
//     )..addListener(() {
//       setState(() {});
//     });
//
//     _transform = Tween<double>(begin: 2, end: 1).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.fastLinearToSlowEaseIn,
//       ),
//     );
//
//     _controller.forward();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: size.height,
//           child: Container(
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Color(0xffFEC37B),
//                   Color(0xffFF4184),
//                 ],
//               ),
//             ),
//             child: Opacity(
//               opacity: _opacity.value,
//               child: Transform.scale(
//                 scale: _transform.value,
//                 child: Container(
//                   width: size.width * .9,
//                   height: size.width * 1.1,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(.1),
//                         blurRadius: 90,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       SizedBox(),
//                       Text(
//                         'Sign In',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black.withOpacity(.7),
//                         ),
//                       ),
//                       SizedBox(),
//
//                       component1(
//                           Icons.email_outlined, 'Email...', false, true, _emailController, (value){
//
//
//                       }),
//                       component1(
//                           Icons.lock_outline, 'Password...', true, false, _passwordController, (value){}),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           component2(
//                             'LOGIN',
//                             2.6,
//                                 () {
//                               HapticFeedback.vibrate();
//                               HapticFeedback.lightImpact();
//
//
//                             },
//                           ),
//                           SizedBox(width: size.width / 25),
//                           Container(
//                             width: size.width / 2.6,
//                             alignment: Alignment.center,
//                             child: RichText(
//                               text: TextSpan(
//                                 text: 'Forgotten password!',
//                                 style: TextStyle(color: Colors.blueAccent),
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                   HapticFeedback.vibrate();
//
//                                   },
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(),
//                       RichText(
//                         text: TextSpan(
//                           text: 'Create a new Account',
//                           style: TextStyle(
//                             color: Colors.blueAccent,
//                             fontSize: 15,
//                           ),
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                             HapticFeedback.vibrate();
//
//                             },
//                         ),
//                       ),
//                       SizedBox(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget component1(
//       IconData icon, String hintText, bool isPassword, bool isEmail, TextEditingController _controller,final validator ) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       height: size.width / 8,
//       width: size.width / 1.22,
//       alignment: Alignment.center,
//       padding: EdgeInsets.only(right: size.width / 30),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(.05),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextFormField(
//         style: TextStyle(color: Colors.black.withOpacity(.8)),
//         obscureText: isPassword,
//         controller: _controller,
//         validator: validator,
//         keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
//         decoration: InputDecoration(
//           prefixIcon: Icon(
//             icon,
//             color: Colors.black.withOpacity(.7),
//           ),
//           border: InputBorder.none,
//           hintMaxLines: 1,
//           hintText: hintText,
//           hintStyle:
//           TextStyle(fontSize: 14, color: Colors.black.withOpacity(.5)),
//
//         ),
//       ),
//     );
//   }
//
//   Widget component2(String string, double width, VoidCallback voidCallback) {
//     Size size = MediaQuery.of(context).size;
//     return InkWell(
//       highlightColor: Colors.transparent,
//       splashColor: Colors.transparent,
//       onTap: voidCallback,
//       child: Container(
//         height: size.width / 8,
//         width: size.width / width,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Color(0xff4796ff),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(
//           string,
//           style: TextStyle(color:
//           Colors.white, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
// }
//
// class MyBehavior extends ScrollBehavior {
//   @override
//   Widget buildViewportChrome(
//       BuildContext context,
//       Widget child,
//       AxisDirection axisDirection,
//       ) {
//     return child;
//   }
// }