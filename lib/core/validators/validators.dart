/// All form validation lives here -- every text field across every
/// auth screen calls into this file rather than each screen writing
/// its own regex. One place to fix a rule, one place it's ever wrong.
class Validators {
  Validators._();

  static final _emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Add at least one uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Add at least one number';
    return null;
  }

  static String? requiredPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Full name is required';
    if (value.trim().length < 2) return 'Enter your full name';
    return null;
  }

  static String? otp(String value, int expectedLength) {
    if (value.length != expectedLength) return 'Enter the full $expectedLength-digit code';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'Code must be numeric';
    return null;
  }
}
