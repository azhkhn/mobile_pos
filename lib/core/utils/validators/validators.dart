class Validators {
  //========== Number Validator ==========
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

  //========== Email Validator ==========
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

  //========== Phone Number Validator ==========
  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required*';
    } else if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(value)) {
      if (value.length != 10) {
        return 'Mobile number must 10 digits';
      } else {
        return 'Please enter a valid Phone Number';
      }
    }

    return null;
  }
}

//Validating email pattern that user entered
RegExp emailValidator = RegExp(r'\S+@\S+\.\S+');
