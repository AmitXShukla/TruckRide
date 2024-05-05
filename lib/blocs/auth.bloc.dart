// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/datamodel.dart';

class AuthBloc extends Object {
  signInWithGoogle() {
    return false;
  }

  logInWithEmail(LoginDataModel model) async {
    final username = model.email.trim();
    final password = model.password.trim();

    final user = ParseUser(username, password, null);
    var response = await user.login();
    return response;
  }
  
  logInWithGoogle(){

  }

  signUpWithEmail(LoginDataModel model) async {
    final username = model.email.trim();
    final email = model.email.trim();
    final password = model.email.trim();

    final user = ParseUser(username, password, email);
    var response = await user.signUp();
    return response;
  }

  resetPassword() async {
    var username = await getUser();
    final ParseUser user = ParseUser(null, null, username?.get("username"));
    final ParseResponse parseResponse = await user.requestPasswordReset();
    return parseResponse;
  }

  Future<ParseUser?> getUser() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  isSignedIn() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse = await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
    if (parseResponse?.success == null || !parseResponse!.success) {
        return false;
      } else {
          return true;
        }
  }

  Future<List<ParseObject>> getData(String classId, String docId) async {
    QueryBuilder<ParseObject> parseQuery = 
      QueryBuilder(ParseObject(classId));
    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
        return apiResponse.results as List<ParseObject>;
        } else {
          return [];
      }
  }

  Future<void> delDoc(String classId, String docId) async {
    var todo = ParseObject(classId)..objectId = docId;
    await todo.delete();
  }

  Future<List<ParseObject>> getSettings(UserDataModel model) async {
    QueryBuilder<ParseObject> parseQuery = 
      QueryBuilder(ParseObject("Settings"));
      parseQuery.whereEqualTo('uid', model.uid);
    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
        return apiResponse.results as List<ParseObject>;
        } else {
          return [];
      }
  }

  Future<bool> setData(String classId, model) async {
    // ParseObject data;

    var dataStr = "";
    model.toJson().forEach((key, value) {
      if(key != 'objectId') {
        dataStr = dataStr + "..set('$key', $value)";
      }
    });
    print(model.toJson()["objectId"]);
    print(dataStr);
    return true;
  }

  Future<bool> setRide(String classId, model) async {
    ParseObject data;
    if (model.objectId == "-") {
            data = ParseObject(classId)
              // ..objectId = model.uid
              ..set('requestor', model.requestor)
              ..set('dttm', model.dttm)
              ..set('from', model.from)
              ..set('to', model.to)
              ..set('message', model.message)
              ..set('loadType', model.loadType)
              ..set('status', model.status)
              ..set('fileURL', model.fileURL);
    } else {
            data = ParseObject(classId)
              ..objectId = model.objectId
              ..set('requestor', model.requestor)
              ..set('dttm', model.dttm)
              ..set('from', model.from)
              ..set('to', model.to)
              ..set('message', model.message)
              ..set('loadType', model.loadType)
              ..set('status', model.status)
              ..set('fileURL', model.fileURL);
    }
    final ParseResponse apiResponse = await data.save();
    if (apiResponse.success && apiResponse.results != null) {
        return true;
        } else {
        return false;
      }
  }

  Future<bool> setSettings(UserDataModel model) async {
    // TODO: Combine all Insert and Update method to Upsert
    // Refactor: all individual class updates to one dynamic function
    // aka pass class ID and model as params and use one generic function to upsert
    // see setData example mention earlier
    // this is why it's important to have Data model and From/TOJson factory methods to
    // serialze and deserialize json data feeds
    ParseObject data;
    if (model.objectId == "-") {
            data = ParseObject('Settings')
              // ..objectId = model.uid
              ..set('uid', model.uid)
              ..set('userName', model.userName)
              ..set('userType', model.userType)
              ..set('name', model.name)
              ..set('email', model.email)
              ..set('phone', model.phone)
              ..set('address', model.address);
    } else {
            data = ParseObject('Settings')
              ..objectId = model.objectId
              ..set('uid', model.uid)
              ..set('userName', model.userName)
              ..set('userType', model.userType)
              ..set('name', model.name)
              ..set('email', model.email)
              ..set('phone', model.phone)
              ..set('address', model.address);
    }
    final ParseResponse apiResponse = await data.save();
    if (apiResponse.success && apiResponse.results != null) {
        return true;
        } else {
        return false;
      }
  }

  Future<bool> setMessage(InboxModel model) async {
    ParseObject data;
    data = ParseObject('Messages')
            ..set('dttm', model.dttm)
            ..set('from', model.from)
            ..set('to', model.to)
            ..set('message', model.message)
            ..set('readReceipt', model.readReceipt)
            ..set('fileURL', model.fileURL);
    final ParseResponse apiResponse = await data.save();
    if (apiResponse.success && apiResponse.results != null) {
        return true;
        } else {
        return false;
      }
  }

  // Future<ParseResponse?> logout() async {
  //   // ignore: unnecessary_null_comparison
  //   // (getUser() == null) ? print("signedin"): print(getUser());
  //   final user = await ParseUser.currentUser() as ParseUser;
  //   var response = await user.logout();
  //   return response;
  // }
  logout() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse = await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
    if (parseResponse?.count == null || parseResponse!.count < 1) {
      //Invalid session. Logout
        return true;
      } else {
          await currentUser.logout();
          return true;
        }
  }
}

final authBloc = AuthBloc();

// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/validators.dart';
// import '../models/datamodel.dart';

// class AuthBloc extends Object with Validators {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   CollectionReference person = FirebaseFirestore.instance.collection('person');
//   CollectionReference appointments =
//       FirebaseFirestore.instance.collection('appointments');
//   CollectionReference vaccine =
//       FirebaseFirestore.instance.collection('vaccine');

//   isSignedIn() {
//     return auth.currentUser != null;
//   }

//   getUID() {
//     return auth.currentUser.uid;
//   }

//   signInWithEmail(LoginDataModel formData) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: formData.email, password: formData.password);
//       return "";
//     } on FirebaseAuthException catch (e) {
//       return e.code;
//     }
//   }

//   signUpWithEmail(LoginDataModel formData) async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: formData.email, password: formData.password);
//       return "";
//     } on FirebaseAuthException catch (e) {
//       return e.code;
//     }
//   }

//   Future<UserCredential> signInWithGoogle() async {
//     // Create a new provider
//     GoogleAuthProvider googleProvider = GoogleAuthProvider();
//     return await FirebaseAuth.instance.signInWithPopup(googleProvider);
//     // Or use signInWithRedirect
//     // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
//   }

//   logout() {
//     try {
//       return FirebaseAuth.instance.signOut();
//     } on FirebaseAuthException catch (e) {
//       return e.code;
//     }
//   }

//   Future getData() async {
//     if (auth.currentUser != null) {
//       return users.doc(auth.currentUser.uid).get();
//     }
//     return false;
//   }

//   Future getUserData(String filter) async {
//     if (auth.currentUser != null) {
//       if (filter == "person") return person.doc(auth.currentUser.uid).get();
//       if (filter == "appointments")
//         return appointments.doc(auth.currentUser.uid).get();
//     }
//     return false;
//   }

//   Future getDocData(String filter, String docId) async {
//     if (auth.currentUser != null) {
//       if (filter == "users") return users.doc(docId).get();
//     }
//     return false;
//   }

//   Future getPatientData(String id) async {
//     if (auth.currentUser != null) {
//       return person.doc(id).get();
//     }
//     return false;
//   }

//   Future getVaccineData(String id) async {
//     if (auth.currentUser != null) {
//       return vaccine.doc(id).get();
//     }
//     return false;
//   }

//   getAppointments() {
//     return FirebaseFirestore.instance
//         .collection('appointments')
//         .where('appointmentDate', isGreaterThan: DateTime.now())
//         .where('appointmentDate',
//             isLessThan: DateTime.now().add(new Duration(days: 2)))
//         .snapshots();
//   }

//   Future setUserData(String filter, formData) async {
//     if (filter == "person")
//       return person.doc(auth.currentUser.uid).set({
//         'name': formData.name,
//         'idType': formData.idType,
//         'id': formData.id,
//         'sir': formData.sir,
//         'occupation': formData.occupation,
//         'warrior': formData.warrior,
//         'dob': formData.name,
//         'gender': formData.gender,
//         'medicalHistory': formData.medicalHistory,
//         'race': formData.race,
//         'address': formData.address,
//         'zipcode': formData.zipcode,
//         'citiesTravelled': formData.citiesTravelled,
//         'siblings': formData.siblings,
//         'familyMembers': formData.familyMembers,
//         'socialActiveness': formData.socialActiveness,
//         'declineParticipation': formData.declineParticipation,
//         'author': auth.currentUser.uid // uid
//       });
//     if (filter == "appointments")
//       return appointments.doc(auth.currentUser.uid).set({
//         'appointmentDate': formData.appointmentDate,
//         'name': formData.name,
//         'phone': formData.phone,
//         'comments': formData.comments,
//         'author': auth.currentUser.uid, // uid
//         'status': formData.status // uid
//       });
//     if (filter == "vaccine")
//       return vaccine.doc(formData.author).set({
//         'appointmentDate': formData.appointmentDate,
//         'newAppointmentDate': formData.newAppointmentDate,
//         'name': formData.name,
//         'idType': formData.idType,
//         'id': formData.id,
//         'sir': formData.sir,
//         'occupation': formData.occupation,
//         'warrior': formData.warrior,
//         'dob': formData.name,
//         'gender': formData.gender,
//         'medicalHistory': formData.medicalHistory,
//         'race': formData.race,
//         'address': formData.address,
//         'zipcode': formData.zipcode,
//         'citiesTravelled': formData.citiesTravelled,
//         'siblings': formData.siblings,
//         'familyMembers': formData.familyMembers,
//         'socialActiveness': formData.socialActiveness,
//         'declineParticipation': formData.declineParticipation,
//         'author': formData.author // uid
//       });
//   }

//   Future<void> setVaccineData(VaccineDataModel formData) async {
//     return person.doc(formData.patientId).collection("Vaccine").add({
//       'appointmentDate': formData.appointmentDate,
//       'newAppointmentDate': formData.newAppointmentDate,
//       'author': formData.patientId
//     });
//   }

//   Future<void> setOPDData(OPDDataModel formData) async {
//     return person.doc(formData.patientId).collection("OPD").add({
//       'opdDate': DateTime.now(),
//       'symptoms': formData.symptoms,
//       'diagnosis': formData.diagnosis,
//       'treatment': formData.treatment,
//       'rx': formData.rx,
//       'lab': formData.lab,
//       'comments': formData.comments,
//       'author': formData.patientId
//     });
//   }

//   Future<void> setMessagesData(MessagesDataModel formData) async {
//     return person.doc(formData.patientId).collection("OPD").add({
//       'messagesDate': DateTime.now(),
//       'from': formData.from,
//       'status': formData.status,
//       'message': formData.message,
//       'readReceipt': formData.readReceipt,
//       'author': formData.patientId
//     });
//   }

//   Future<void> setRxData(RxDataModel formData) async {
//     return person.doc(formData.patientId).collection("Rx").add({
//       'rxDate': DateTime.now(),
//       'from': formData.from,
//       'status': formData.status,
//       'rx': formData.rx,
//       'results': formData.results,
//       'descr': formData.descr,
//       'comments': formData.comments,
//       'author': formData.patientId
//     });
//   }

//   Future<void> setLABData(LabDataModel formData) async {
//     return person.doc(formData.patientId).collection("Lab").add({
//       'labDate': DateTime.now(),
//       'from': formData.from,
//       'status': formData.status,
//       'lab': formData.lab,
//       'results': formData.results,
//       'descr': formData.descr,
//       'comments': formData.comments,
//       'author': formData.patientId
//     });
//   }

//   Future<void> setData(SettingsDataModel formData) async {
//     return users.doc(auth.currentUser.uid).set({
//       'name': formData.name, // John Doe
//       'phone': formData.phone, // Phone
//       'email': formData.email,
//       'role': formData.role,
//       'author': auth.currentUser.uid // uid
//     });
//   }

//   Future<void> updData(SettingsDataModel formData) async {
//     return users.doc(formData.author).set({
//       'name': formData.name, // John Doe
//       'phone': formData.phone, // Phone
//       'email': formData.email,
//       'role': formData.role,
//       'author': formData.author // uid
//     });
//   }

//   // API: dispose/cancel observables/subscriptions
//   dispose() {}
// }

// final authBloc = AuthBloc();
