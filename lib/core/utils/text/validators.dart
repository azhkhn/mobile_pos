class Validators {
  String? numberValidator(String? value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }
}

//Validating email pattern that user entered
RegExp emailValidator = RegExp(r'\S+@\S+\.\S+');
