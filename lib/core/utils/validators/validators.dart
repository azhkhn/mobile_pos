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

  static String? vatValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final vat = num.tryParse(value);
    if (vat == null || value.length != 15) {
      return 'Please enter a valid VAT number';
    }

    return null;
  }
}

//Validating email pattern that user entered
RegExp emailValidator = RegExp(r'\S+@\S+\.\S+');
