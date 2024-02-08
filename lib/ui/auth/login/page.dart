import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectTeraform/ui/auth/login/bloc/login_bloc.dart';
import 'package:projectTeraform/ui/auth/registration/page.dart';
import 'package:projectTeraform/ui/global_components/custom_button.dart';
import 'package:projectTeraform/ui/root/root_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthenticationBloc(),
        child: SingleChildScrollView(
            child: Container(
                child: Form(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Container(
                            height: size.height / 3,
                            width: size.width,
                            child: const Center(
                              child: Text(" Login"),
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            decoration: const InputDecoration(
                                hintText: 'Email',
                                focusedBorder: OutlineInputBorder(),
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: 'Password',
                                focusedBorder: OutlineInputBorder(),
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          BlocConsumer<AuthenticationBloc, AuthenticationState>(
                            listener: (context, state) {


                              // TODO: implement listener
                              if (state is AuthenticationSuccessState) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                        builder: (context) => const RootPage()));

                                // Dismiss loading indicator if it's still open
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              }
                              else if(state is AuthenticationLoadingState){

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Logging In...'),
                                          CircularProgressIndicator(),
                                        ],
                                      ),
                                    ),
                                  );
                              }

                              else if (state is AuthenticationFailureState) {

                                // Dismiss loading dialog if it's still open
                                // Show failure snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Login Failed, Please try again'),
                                    duration: const Duration(seconds: 3), // Adjust duration as needed
                                    action: SnackBarAction(
                                      label: 'Dismiss',
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      },
                                    ),
                                  ),
                                );
                              }



                            },
                            builder: (context, state) {

                                return CustomButton(
                                  onTap: () {
                                    HapticFeedback.vibrate();
                                    BlocProvider.of<AuthenticationBloc>(context).add(
                                      SignInUser(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                      ),
                                    );
                                  },
                                  height: 55,
                                  width: 300,
                                  buttonText: const Text('Login'),
                                  buttonColor: Colors.orangeAccent,
                                );
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: Row(
                              children: [
                                const Text(' Dont have an account?'),
                                const SizedBox(
                                  width: 8,
                                ),
                                 GestureDetector(

                                     child: const Text('Register Now'),
                                 onTap: (){

                                       Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage()));

                                 },
                                 )
                              ],
                            ),
                          )
                        ],
                      ),
                    )))


        ),
      ),
    );
  }
}
//
