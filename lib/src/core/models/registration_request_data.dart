class RegistrationRequestData {
  const RegistrationRequestData({required this.email, required this.password, required this.fullName});
  final String email;
  final String password;
  final String fullName;
  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
      };
}
