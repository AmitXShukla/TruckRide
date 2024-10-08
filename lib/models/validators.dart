// import 'dart:async';

class Validators {
//   final validateEmail =
//       StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
//     String pattern =
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = RegExp(pattern);
//     if (regex.hasMatch(email)) {
//       sink.add(email);
//     } else {
//       sink.addError('Please enter a valid email');
//     }
//     });

//   final validatePassword = StreamTransformer<String, String>.fromHandlers(
//       handleData: (password, sink) {
//     if (password.length > 4) {
//       sink.add(password);
//     } else {
//       sink.addError('Invalid password, please enter more than 4 characters');
//     }
//   });

//   final validateText =
//       StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
//     if (name.length > 3) {
//       sink.add(name);
//     } else {
//       sink.addError('Invalid Text, please enter minimum 4 characters');
//     }
//   });

  String? evalPassword(String value) {
  String pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (value.isEmpty) {
    return "password is Required";
  } else if (!regex.hasMatch(value)) {
    return 'please enter 8 chars alphanumeric password';
  }
    return null;
}

String? evalEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (value.isEmpty) {
    return "email is required";
  } else if (!regex.hasMatch(value)) {
    return 'please enter valid email';
  }
    return null;
}

String? evalName(String value) {
  if (value.length < 4) {
    return "please enter min. 4 chars text";
  }
  return null;
}

String? evalChar(String value) {
  if (value.length < 5) {
    return "please enter min. 10 chars text";
  }
  return null;
}

String? evalPhone(String value) {
  // String pattern = r'^[2-9]\d{2}-\d{3}-\d{4}$';
  String pattern = r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$';
  RegExp regex = RegExp(pattern);
  if (value.isEmpty) {
    return "phone is required";
  } else if (!regex.hasMatch(value)) {
    return 'ex. +1 212-000-0000';
  }
    return null;
}

String? evalDate(String value) {
  // String pattern = r'^[2-9]\d{2}-\d{3}-\d{4}$';
  String pattern = r'^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$';
  RegExp regex = RegExp(pattern);
  if (value.isEmpty) {
    return "date is required";
  } else if (!regex.hasMatch(value)) {
    return 'ex. 01/31/2025';
  }
    return null;
}

String? evalNumber(String value) {
  // String pattern = r'^[2-9]\d{2}-\d{3}-\d{4}$';
  String pattern = r'^[+-]?(\d*\.)?\d+$';
  RegExp regex = RegExp(pattern);
  if (value.isEmpty) {
    return "valid numbers only";
  } else if (!regex.hasMatch(value)) {
    return 'ex. 99.99';
  }
    return null;
}

}

final validatorBloc = Validators();