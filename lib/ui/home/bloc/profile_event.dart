part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {

  const ProfileEvent();
}




class HomeLoaded extends ProfileEvent{


  final String fname;
  final String lname;

  const HomeLoaded({required this.fname, required this.lname});
}
