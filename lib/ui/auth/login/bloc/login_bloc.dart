import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../configuration/models/user_model.dart';
import '../../../../configuration/services/authentication.dart';
part 'login_event.dart';
part 'login_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService = AuthService();

  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignInUser>((event, emit) async{
      emit(AuthenticationLoadingState(isLoading: true));
     try{
       final UserModel? user =
           await authService.signInUser(event.email, event.password);
       if(user != null){
         emit(AuthenticationSuccessState(user));
         emit(AuthenticationLoadingState(isLoading: false));
       }else{
         emit(AuthenticationFailureState('Login Failed'));
       }


     }catch (e){
       log('e');
     }
     emit (AuthenticationLoadingState(isLoading: false));
    });



    on<SignOut>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        authService.signOutUser();
      } catch (e) {
        print('error');
        print(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
}