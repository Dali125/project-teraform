import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectTeraform/configuration/models/rigistration_model.dart';
import 'package:projectTeraform/configuration/models/user_model.dart';
import 'package:projectTeraform/ui/auth/login/page.dart';
import 'package:projectTeraform/ui/auth/registration/bloc/register_bloc.dart';
import 'package:projectTeraform/ui/auth/registration/components/custom_text_fields.dart';
import 'package:projectTeraform/ui/global_components/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectTeraform/ui/root/root_page.dart';

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
        
        
        
                children: [
        
                  SizedBox(
                    height: size.height/ 5,
                  ),
        
                  const Text('Register to Project Teraform'),
                  const Text('Not final Registration page, only for prototype'),
        
        
                  const SizedBox(
                    height: 100,
                  ),
                  CustomField(
                      controller: _firstNameController,
                      obscureText: false, textInputType: TextInputType.name,
                      hintText: 'First Name'),
                  const SizedBox(
                    height: 12,
                  ),

                  CustomField(
                      controller: _lastNameController,
                      obscureText: false, textInputType: TextInputType.name,
                      hintText: 'Last Name'),
                  const SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context)
                    ,
                    child: AbsorbPointer(
                      child: CustomField(
                          controller: _birthDateController,
                          obscureText: false, textInputType: TextInputType.name,
                          hintText: 'BirthDate'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  CustomField(
                      controller: _emailcontroller,
                      obscureText: false, textInputType: TextInputType.name,
                      hintText: 'Email'),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomField(
                      controller: _passwordController,
                      obscureText: true, textInputType: TextInputType.name,
                      hintText: 'Password'),

                  const SizedBox(
                    height: 12,
                  ),
                  BlocConsumer<RegisterBloc, RegisterState>(
  listener: (context, state) {
    if(state is RegistrationFailed){

      showCupertinoDialog(
          context: context, builder: (context) {
        return  Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: CupertinoActionSheet(
              message: const Text('Login Failed, Please try again'),
              actions: [
                CupertinoActionSheetAction(onPressed: (){
                  Navigator.of(context).pop();
                }, child: const Text('Dismiss'))
              ],
            ),
          ),
        );
      });
    }else if(state is RegistrationSuccess){

      showCupertinoDialog(
          context: context, builder: (context) {
        return  Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: CupertinoActionSheet(
              title: Text('Registering, Complete'),
              message: Center(child: Icon(Icons.check)),
              actions: [
                CupertinoActionSheetAction(onPressed: () async {

                  Navigator.pushReplacement(context, (MaterialPageRoute(builder: (context) => RootPage())));

                }, child: Text('Proceed to Home'))
              ],

            ),
          ),
        );
      });
    }

    else if (state is RegistrationLoadingState){


      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    return CustomButton(onTap: (){
                    HapticFeedback.vibrate();
                    BlocProvider.of<RegisterBloc>(context).add(SignUpUser(_emailcontroller.text.trim()
                        , _passwordController.text.trim(),
                        RegistrationModel(
                            firstName: _firstNameController.text.trim(),
                        lastName:    _lastNameController.text.trim(),
                          email: _emailcontroller.text.trim(),
                          password: _passwordController.text.trim(),
                          birthdate:  _selectedDate

                        )));





                  }, height: 60, width: 300, buttonText: const Text('Register'),
                  buttonColor: Colors.orange,);
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
