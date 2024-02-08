import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:projectTeraform/configuration/models/user_model.dart';
import '../../../../configuration/models/rigistration_model.dart';
import '../../../../configuration/services/authentication.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  final AuthService authService = AuthService();
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<SignUpUser>((event, emit)async  {

      emit(const RegistrationLoadingState(true));


      try{
        final UserModel? user = await authService.
        signUpUser(event.email, event.password, event.model);
        if(user != null){
          emit(RegistrationSuccess(user));



        }else{
          emit(RegistrationFailed());
          log('Registration Failed');
        }



      }catch (e){

        log('$e');


      }
      emit(const RegistrationLoadingState(false));

    });
  }
}
