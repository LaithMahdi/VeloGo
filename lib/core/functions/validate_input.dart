enum InputType { email, number, decimal, password, text }

/// Validates a text input field based on type, length, and requirement.
/// Returns a descriptive error message if invalid, otherwise `null`.
String? validateInput(
  String? value, {
  int min = 2,
  int max = 100,
  InputType type = InputType.text,
  bool isRequired = true,
}) {
  // Handle optional fields
  if ((value == null || value.isEmpty) && !isRequired) {
    return null;
  }

  // Required validation
  if (value == null || value.isEmpty) {
    return "This field is required.";
  }

  // Length validation
  if (value.length < min) {
    return "Must be at least $min characters long.";
  }

  if (value.length > max) {
    return "Must be less than $max characters long.";
  }

  // Type-specific validation
  switch (type) {
    case InputType.email:
      final emailRegex = RegExp(r"^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$");
      if (!emailRegex.hasMatch(value)) {
        return "Please enter a valid email address.";
      }
      break;

    case InputType.number:
      final cleanedValue = value.replaceAll(' ', '');
      final numberRegex = RegExp(r'^[0-9]+$');

      if (!numberRegex.hasMatch(cleanedValue)) {
        return "Only numeric characters are allowed.";
      }
      if (cleanedValue.length < min) {
        return "Must be at least $min digits long.";
      }
      if (cleanedValue.length > max) {
        return "Must be less than $max digits long.";
      }
      break;

    case InputType.decimal:
      if (double.tryParse(value) == null) {
        return "Please enter a valid decimal number.";
      }
      break;

    case InputType.password:
      // Add stronger password rules if needed
      break;

    case InputType.text:
      break;
  }

  return null;
}

/// Validates a password confirmation field.
/// Returns a descriptive message if not matching.
String? validateConfirmPassword(
  String? value,
  String originalPassword, {
  bool isRequired = true,
}) {
  final error = validateInput(
    value,
    min: 6,
    max: 25,
    type: InputType.password,
    isRequired: isRequired,
  );

  if (error != null) return error;

  if (value != originalPassword) {
    return "Passwords do not match.";
  }

  return null;
}

/// Validates a dropdown/select field.
String? validateSelect(String? value, {bool isRequired = true}) {
  if (!isRequired) return null;
  if (value == null || value.isEmpty) {
    return "Please select an option.";
  }
  return null;
}
