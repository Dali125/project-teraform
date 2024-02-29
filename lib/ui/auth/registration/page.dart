import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projectTeraform/configuration/models/rigistration_model.dart';

import 'package:projectTeraform/ui/auth/registration/bloc/register_bloc.dart';
import 'package:projectTeraform/ui/auth/registration/components/custom_text_fields.dart';
import 'package:projectTeraform/ui/global_components/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectTeraform/ui/root/root_page.dart';
import 'package:projectTeraform/utils.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  DateTime? _selectedDate;

  ///Selecting the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        int date = _selectedDate!.day;
        int month = _selectedDate!.month;
        int year = _selectedDate!.year;

        _birthDateController.text = '$year-$month-$date';
      });
    }
  }

  final _emailcontroller = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: PopScope(
            child: Container(
              height: size.height,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 52.h,
                    ),
                    Text(
                      "Sign Up to Teraform",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: darkTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Wrap(
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: lightTextColor,
                          ),
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: purpleColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomField(
                        controller: _firstNameController,
                        obscureText: false,
                        textInputType: TextInputType.name,
                        hintText: 'First Name'),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomField(
                        controller: _lastNameController,
                        obscureText: false,
                        textInputType: TextInputType.name,
                        hintText: 'Last Name'),
                    SizedBox(
                      height: 16.h,
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: CustomField(
                            controller: _birthDateController,
                            obscureText: false,
                            textInputType: TextInputType.name,
                            hintText: 'BirthDate'),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomField(
                        controller: _emailcontroller,
                        obscureText: false,
                        textInputType: TextInputType.name,
                        hintText: 'Email'),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputType: TextInputType.name,
                        hintText: 'Password'),
                    SizedBox(
                      height: 16.h,
                    ),
                    BlocConsumer<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegistrationFailed) {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Center(
                                    child: CupertinoActionSheet(
                                      message: const Text(
                                          'Login Failed, Please try again'),
                                      actions: [
                                        CupertinoActionSheetAction(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Dismiss'))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else if (state is RegistrationSuccess) {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Center(
                                    child: CupertinoActionSheet(
                                      title: Text('Registering, Complete'),
                                      message: Center(child: Icon(Icons.check)),
                                      actions: [
                                        CupertinoActionSheetAction(
                                            onPressed: () async {
                                              Navigator.pushReplacement(
                                                  context,
                                                  (MaterialPageRoute(
                                                      builder: (context) =>
                                                          RootPage())));
                                            },
                                            child: Text('Proceed to Home'))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else if (state is RegistrationLoadingState) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Registering, please wait..'),
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              ),
                            );
                        }
                      },
                      builder: (context, state) {
                        return CustomButton(
                          onTap: () {
                            HapticFeedback.vibrate();
                            BlocProvider.of<RegisterBloc>(context).add(
                                SignUpUser(
                                    _emailcontroller.text.trim(),
                                    _passwordController.text.trim(),
                                    RegistrationModel(
                                        firstName:
                                            _firstNameController.text.trim(),
                                        lastName:
                                            _lastNameController.text.trim(),
                                        email: _emailcontroller.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                        birthdate: _selectedDate)));
                          },
                          height: 60,
                          width: size.width,
                          buttonText: const Text('Register'),
                          buttonColor: Colors.orange,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
