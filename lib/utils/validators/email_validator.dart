String emailValidator(String value) {
  if (value.isEmpty) {
    return 'Please enter an email address';
  }
  if (!isValidEmail(value)) {
    return 'Please enter a valid email address';
  } else {
    return null;
  }
}

bool isValidEmail(String value) {
  return RegExp(
          r'(?=.{6,320}$)^[a-zA-Z0-9_.+-]{1,64}@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,}$')
      .hasMatch(value);
}
