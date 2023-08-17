/// mixin to check input validators
mixin InputValidationMixin {
  ///
  final emailInputPattern = '[a-z0-9@-_.]';

  ///
  final emailValidationPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  /// checks if provided password is valid

  bool isPasswordValid({required String password}) => password.length >= 8;

  /// Checks if provided email is valid
  bool isEmailValid({required String email}) {

    /// define regular expression
    final regex = RegExp(emailValidationPattern);
    return regex.hasMatch(email);
  }

  /// Check if provided phone number is valid
  bool isPhoneNumberValid({required String phoneNumber}) {
    /// define regEx pattern
    const pattern = r'^\d{9,}$';

    /// define regular expression
    final regex = RegExp(pattern);
    return regex.hasMatch(phoneNumber);
  }
}
