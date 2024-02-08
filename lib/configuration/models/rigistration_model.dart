class RegistrationModel{

  final String firstName;
  final String lastName;
  final String email;
  final DateTime? birthdate;
  final String password;


  const RegistrationModel({required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthdate,
    required this.password});
}