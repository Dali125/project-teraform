part of 'register_bloc.dart';

@immutable
abstract class RegisterState {

  const RegisterState();
}

class RegisterInitial extends RegisterState {}




class RegistrationLoadingState extends RegisterState{

  final bool isLoading;
  const RegistrationLoadingState(this.isLoading);

  String toString() => 'is registation Loading? $isLoading';

  List<Object> get props => [isLoading];
}

class RegistrationSuccess extends RegisterState {
  final UserModel? user;
  const RegistrationSuccess(this.user);

  List<UserModel?> get props => [user];
}

class RegistrationFailed extends RegisterState {

}
