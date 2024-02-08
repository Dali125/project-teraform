part of 'register_bloc.dart';


@immutable
abstract class RegisterEvent {
  const RegisterEvent();
}



///Event to
class SignUpUser extends RegisterEvent {


  final String email;
  final String password;
  final RegistrationModel model;


   const SignUpUser(this.email, this.password, this.model);

   List<Object> get props => [email, password];
}
