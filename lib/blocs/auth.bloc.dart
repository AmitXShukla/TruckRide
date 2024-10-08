import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/datamodel.dart';

class AuthBloc extends Object {
  // authentication functions starts
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

  setUserACLs() async {
    final ParseCloudFunction function = ParseCloudFunction("setUsersAcls");
    final ParseResponse parseResponse = await function.execute();
    if (parseResponse.success && parseResponse.result != null) {
      return true;
    }
    return false;
  }

  logInWithGoogle() {}

  signUpWithEmail(LoginDataModel model) async {
    final username = model.email.trim();
    final email = model.email.trim();
    final password = model.password.trim();

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

  forgotPassword(String uname) async {
    final ParseUser user = ParseUser(null, null, uname);
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
    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
    if (parseResponse?.success == null || !parseResponse!.success) {
      return false;
    } else {
      return true;
    }
  }

  logout() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
    if (parseResponse?.count == null || parseResponse!.count < 1) {
      //Invalid session. Logout
      return true;
    } else {
      await currentUser.logout();
      return true;
    }
  }
// authentication functions ends

// user settings functions starts
  getUserSettingsDoc() async {
    final ParseCloudFunction function = ParseCloudFunction("getProfile");
    final ParseResponse parseResponse = await function.execute();
    if (parseResponse.success && parseResponse.result != null) {
      return parseResponse.result[0];
    }
  }

  getUserSettingsDocADMIN(String objectId) async {
    final ParseCloudFunction function;
    final Map<String, dynamic> params;
    function = ParseCloudFunction("getProfileADMIN");
    params = <String, dynamic>{'objectId': objectId};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    // print(parseResponse.results?[0]["result"][0].objectId);
    if (parseResponse.success && parseResponse.result != null) {
      return parseResponse.results?[0]["result"][0];
    }
  }
  // getUserRideDocADMIN(String objectId) async {
  //   print(objectId);
  //   final ParseCloudFunction function;
  //   final Map<String, dynamic> params;
  //   function = ParseCloudFunction("getUserRideDocADMIN");
  //   params = <String, dynamic>{
  //       'objectId': objectId
  //     };
  //   final ParseResponse parseResponse =
  //     await function.executeObjectFunction<ParseObject>(parameters: params);
  //   // print(parseResponse.results?[0]["result"][0].objectId);
  //   if (parseResponse.success && parseResponse.result != null) {
  //     return parseResponse.results?[0]["result"][0];
  //   }
  // }

  setUserSettingsDocADMIN(UserDataModel model) async {
    final ParseCloudFunction function;
    final Map<String, dynamic> params;
    function = ParseCloudFunction("setProfileADMIN");
    params = <String, dynamic>{
      'objectId': model.objectId,
      'uid': model.uid,
      'username': model.userName,
      'userType': model.userType,
      'name': model.name,
      'email': model.email,
      'phone': model.phone,
      'address': model.address
    };

    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.result != null) {
      return true;
    }
    return false;
  }

  setUserSettingsDoc(UserDataModel model) async {
    final ParseCloudFunction function = ParseCloudFunction("setProfile");
    final Map<String, dynamic> params = <String, dynamic>{
      'objectId': model.objectId,
      'username': model.userName,
      'userType': model.userType,
      'name': model.name,
      'email': model.email,
      'phone': model.phone,
      'address': model.address
    };
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.result != null) {
      return true;
    }
    return false;
  }

  // setUserSettingsDoc(UserDataModel model) async {
  //   final ParseCloudFunction function;
  //   final Map<String, dynamic> params;
  //   if (model.objectId == "-") {
  //     function = ParseCloudFunction("setProfile");
  //     params = <String, dynamic>{
  //       'username': model.userName,
  //       'userType': model.userType,
  //       'name': model.name,
  //       'email': model.email,
  //       'phone': model.phone,
  //       'address': model.address
  //     };
  //   } else {
  //     function = ParseCloudFunction("updateUserSettingsDoc");
  //     params = <String, dynamic>{
  //       'objectId': model.objectId,
  //       'username': model.userName,
  //       'userType': model.userType,
  //       'name': model.name,
  //       'email': model.email,
  //       'phone': model.phone,
  //       'address': model.address
  //     };
  //   }

  //   final ParseResponse parseResponse =
  //     await function.executeObjectFunction<ParseObject>(parameters: params);
  //   if (parseResponse.success && parseResponse.result != null) {
  //     return true;
  //   }
  //   return false;
  // }

  // getUserRidesADMIN(String objectId) async {
  //   final ParseCloudFunction function;
  //   final Map<String, dynamic> params;
  //   function = ParseCloudFunction("getUserRidesADMIN");
  //   params = <String, dynamic>{
  //       'objectId': objectId
  //     };
  //   final ParseResponse parseResponse =
  //     await function.executeObjectFunction<ParseObject>(parameters: params);
  //   if (parseResponse.success && parseResponse.result != null) {
  //     // return parseResponse.results;
  //     return parseResponse.results?[0]["result"];
  //   }
  // }
// user settings functions ends

// user doc functions starts
  setUserFileDoc(String docType, String docId, file) async {
    final ParseCloudFunction function;
    final Map<String, dynamic> params;
    function = ParseCloudFunction("setDocs");
    params = <String, dynamic>{
      'docType': docType,
      'docId': docId,
      'file': file
    };

    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.result != null) {
      return true;
    }
    return false;
  }

  setUserFileDocADMIN(String docType, String docId, String uid, file) async {
    final ParseCloudFunction function;
    final Map<String, dynamic> params;
    function = ParseCloudFunction("setDocsADMIN");
    params = <String, dynamic>{
      'docType': docType,
      'docId': docId,
      'uid': uid,
      'file': file
    };

    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.result != null) {
      return true;
    }
    return false;
  }

  Future<List> getGalleryList(String docType, String docId) async {
    final ParseCloudFunction function;
    final Map<String, dynamic> params;
    function = ParseCloudFunction("getDocs");
    params = <String, dynamic>{
      'docType': docType,
      'docId': docId,
    };
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    // print(parseResponse.results?[0]["result"]);
    if (parseResponse.success && parseResponse.result != null) {
      return parseResponse.results?[0]["result"] as List;
    }
    return [];
  }

  Future<List> getGalleryListADMIN(
      String docType, String docId, String uid) async {
    final ParseCloudFunction function;
    final Map<String, dynamic> params;
    function = ParseCloudFunction("getDocsADMIN");
    params = <String, dynamic>{
      'docType': docType,
      'docId': docId,
      'uid': uid,
    };
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    // print(parseResponse.results?[0]["result"]);
    if (parseResponse.success && parseResponse.result != null) {
      return parseResponse.results?[0]["result"] as List;
    }
    return [];
  }

  // Future<List<ParseObject>> getGalleryList(String docType) async {
  //   QueryBuilder<ParseObject> queryPublisher =
  //       QueryBuilder<ParseObject>(ParseObject('Gallery'))
  //         ..orderByAscending('createdAt');
  //   final ParseResponse apiResponse = await queryPublisher.query();
  //   print(apiResponse.result);

  //   if (apiResponse.success && apiResponse.results != null) {
  //     return apiResponse.results as List<ParseObject>;
  //   } else {
  //     return [];
  //   }
  // }
// user doc functions ends

// bid functions starts

  Future getBiddableRides(String? srchTxt) async {
    // Future<List<ParseObject>> getBiddableRides(String classId) async {
    // QueryBuilder<ParseObject> parseQuery = QueryBuilder(ParseObject(classId));
    // parseQuery.whereEqualTo('status', "new");
    // parseQuery.setLimit(10);
    // parseQuery.orderByDescending('createdAt');

    // final ParseResponse apiResponse = await parseQuery.query();
    // if (apiResponse.success && apiResponse.results != null) {
    //   return apiResponse.results as List<ParseObject>;
    // } else {
    //   return [];
    // }
    final ParseCloudFunction function = ParseCloudFunction("getBiddableRides");
    final Map<String, dynamic> params = <String, dynamic>{'srchTxt': srchTxt};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    // print(parseResponse.results);
    if (parseResponse.success && parseResponse.results != null) {
      return (parseResponse.results as List)[0]["result"];
    } else {
      return [];
    }
  }

  // Future<bool> setBid(String classId, model) async {
  //   ParseObject data;
  //   if (model.objectId == "-") {
  //     data = ParseObject(classId)
  //       // ..objectId = model.uid
  //       ..set('rideId', model.rideId)
  //       ..set('rideDttm', model.rideDttm)
  //       ..set('uid', model.uid)
  //       ..set('driver', model.driver)
  //       ..set('from', model.from)
  //       ..set('to', model.to)
  //       ..set('status', model.status)
  //       ..set('fileURL', model.fileURL)
  //       ..set('bid', model.bid)
  //       ..set('message', model.message);
  //   } else {
  //     data = ParseObject(classId)
  //       ..objectId = model.objectId
  //       ..set('rideId', model.rideId)
  //       ..set('rideDttm', model.rideDttm)
  //       ..set('uid', model.uid)
  //       ..set('driver', model.driver)
  //       ..set('from', model.from)
  //       ..set('to', model.to)
  //       ..set('status', model.status)
  //       ..set('fileURL', model.fileURL)
  //       ..set('bid', model.bid)
  //       ..set('message', model.message);
  //   }
  //   final ParseResponse apiResponse = await data.save();
  //   if (apiResponse.success && apiResponse.results != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  Future<bool> setBid(BidModel model) async {
    print(model.rideId);
    print(model.rideDttm);
    print(model.from);
    print(model.to);
    print(model.bid);
    print(model.message);
    final ParseCloudFunction function = ParseCloudFunction("setBid");
    final Map<String, dynamic> params = <String, dynamic>{
      'objectId': model.objectId,
      'rideId': model.rideId,
      'rideDttm': model.rideDttm,
      'uid': model.uid,
      'driver': model.driver,
      'from': model.from,
      'to': model.to,
      'status': model.status,
      'fileURL': model.fileURL,
      'bid': model.bid,
      'message': model.message
    };
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.result != null) {
      return true;
    }
    return false;
  }

  Future<bool> setBidADMIN(BidModel model) async {
    final ParseCloudFunction function = ParseCloudFunction("setBidADMIN");
    final Map<String, dynamic> params = <String, dynamic>{
      'objectId': model.objectId,
      'rideId': model.rideId,
      'rideDttm': model.rideDttm,
      'uid': model.uid,
      'driver': model.driver,
      'from': model.from,
      'to': model.to,
      'status': model.status,
      'fileURL': model.fileURL,
      'bid': model.bid,
      'message': model.message
    };
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.result != null) {
      return true;
    }
    return false;
  }
// Future<List<ParseObject>> getBids(String classId, String docId) async {
//     // userID
//     var username = await authBloc.getUser();
//     var uid =
//         (username?.get("objectId") == null) ? "-" : username?.get("objectId");
//     // docId = (docId == "-") ? "driver" : "uid";

//     QueryBuilder<ParseObject> parseQuery = QueryBuilder(ParseObject(classId));
//     parseQuery.whereEqualTo(docId, uid);
//     parseQuery.setLimit(10);
//     parseQuery.orderByDescending('createdAt');

//     final ParseResponse apiResponse = await parseQuery.query();
//     if (apiResponse.success && apiResponse.results != null) {
//       return apiResponse.results as List<ParseObject>;
//     } else {
//       return [];
//     }
//   }
  Future getBids(String? srchTxt) async {
    final ParseCloudFunction function = ParseCloudFunction("getBids");
    final Map<String, dynamic> params = <String, dynamic>{'srchTxt': srchTxt};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    // print(parseResponse.results);
    if (parseResponse.success && parseResponse.results != null) {
      return (parseResponse.results as List)[0]["result"];
    } else {
      return [];
    }
  }

  Future getBidsForRide(String? rideId) async {
    final ParseCloudFunction function = ParseCloudFunction("getBidsForRide");
    final Map<String, dynamic> params = <String, dynamic>{'rideId': rideId};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    // print(parseResponse.results);
    if (parseResponse.success && parseResponse.results != null) {
      return (parseResponse.results as List)[0]["result"];
    } else {
      return [];
    }
  }

  Future getBidDoc(String docId) async {
    // QueryBuilder<ParseObject> parseQuery = QueryBuilder(ParseObject(classId));
    // parseQuery.whereEqualTo('objectId', docId);
    // parseQuery.orderByDescending('createdAt');

    // final ParseResponse apiResponse = await parseQuery.query();
    // if (apiResponse.success && apiResponse.results != null) {
    //   return apiResponse.results as List<ParseObject>;
    // } else {
    //   return [];
    // }
    final ParseCloudFunction function = ParseCloudFunction("getBid");
    final Map<String, dynamic> params = <String, dynamic>{'objectId': docId};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    // print(parseResponse.results);
    if (parseResponse.success && parseResponse.results != null) {
      return (parseResponse.results as List)[0]["result"];
    } else {
      return [];
    }
  }
// bid functions ends

  Future<List<ParseObject>> getData(String classId, String docId) async {
    // userID
    var username = await authBloc.getUser();
    var uid =
        (username?.get("objectId") == null) ? "-" : username?.get("objectId");

    QueryBuilder<ParseObject> parseQuery = QueryBuilder(ParseObject(classId));
    parseQuery.whereEqualTo('uid', uid);
    parseQuery.setLimit(10);
    parseQuery.orderByDescending('createdAt');

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  // Future<List<ParseObject>> getBidsForRide(String classId, String docId) async {
  //   QueryBuilder<ParseObject> parseQuery = QueryBuilder(ParseObject(classId));
  //   parseQuery.whereEqualTo("rideId", docId);
  //   parseQuery.setLimit(10);
  //   parseQuery.orderByDescending('createdAt');

  //   final ParseResponse apiResponse = await parseQuery.query();
  //   if (apiResponse.success && apiResponse.results != null) {
  //     return apiResponse.results as List<ParseObject>;
  //   } else {
  //     return [];
  //   }
  // }

  // Future<List<ParseObject>> getRideDoc(String classId, String docId) async {
  //   QueryBuilder<ParseObject> parseQuery =
  //     QueryBuilder(ParseObject(classId));
  //     parseQuery.whereEqualTo('objectId', docId);
  //     parseQuery.orderByDescending('createdAt');

  //   final ParseResponse apiResponse = await parseQuery.query();
  //   if (apiResponse.success && apiResponse.results != null) {
  //       return apiResponse.results as List<ParseObject>;
  //       } else {
  //         return [];
  //     }
  // }

  Future<List<ParseObject>> getDoc(String classId, String docId) async {
    var username = await authBloc.getUser();
    var uid =
        (username?.get("objectId") == null) ? "-" : username?.get("objectId");
    QueryBuilder<ParseObject> parseQuery = QueryBuilder(ParseObject(classId));
    parseQuery.whereEqualTo('uid', uid);
    parseQuery.whereEqualTo('objectId', docId);
    parseQuery.orderByDescending('createdAt');

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

  // Future<List<ParseObject>> getSettings(UserDataModel model) async {
  //   QueryBuilder<ParseObject> parseQuery =
  //     QueryBuilder(ParseObject("Settings"));
  //     parseQuery.whereEqualTo('uid', model.uid);
  //     parseQuery.orderByDescending('createdAt');
  //   final ParseResponse apiResponse = await parseQuery.query();
  //   if (apiResponse.success && apiResponse.results != null) {
  //       return apiResponse.results as List<ParseObject>;
  //       } else {
  //         return [];
  //     }
  // }

  // Future<List<ParseObject>> getUserType() async {
  //   var username = await authBloc.getUser();
  //   var uid = (username?.get("objectId") ==  null) ? "-" : username?.get("objectId");

  //   QueryBuilder<ParseObject> parseQuery =
  //     QueryBuilder(ParseObject("Settings"));
  //     parseQuery.whereEqualTo('uid', uid);
  //     parseQuery.orderByDescending('createdAt');
  //   final ParseResponse apiResponse = await parseQuery.query();
  //   if (apiResponse.success && apiResponse.results != null) {
  //       return apiResponse.results as List<ParseObject>;
  //       } else {
  //         return [];
  //     }
  // }

  Future<bool> setData(String classId, model) async {
    // ParseObject data;

    var dataStr = "";
    model.toJson().forEach((key, value) {
      if (key != 'objectId') {
        dataStr = dataStr + "..set('$key', $value)";
      }
    });
    print(model.toJson()["objectId"]);
    print(dataStr);
    return true;
  }

  // Future<bool> setRide(String classId, model) async {
  //   ParseObject data;
  //   if (model.objectId == "-") {
  //           data = ParseObject(classId)
  //             // ..objectId = model.uid
  //             ..set('uid', model.uid)
  //             ..set('dttm', model.dttm)
  //             ..set('from', model.from)
  //             ..set('to', model.to)
  //             ..set('message', model.message)
  //             ..set('loadType', model.loadType)
  //             ..set('status', model.status)
  //             ..set('fileURL', model.fileURL);
  //   } else {
  //           data = ParseObject(classId)
  //             ..objectId = model.objectId
  //             ..set('uid', model.uid)
  //             ..set('dttm', model.dttm)
  //             ..set('from', model.from)
  //             ..set('to', model.to)
  //             ..set('message', model.message)
  //             ..set('loadType', model.loadType)
  //             ..set('status', model.status)
  //             ..set('fileURL', model.fileURL);
  //   }
  //   final ParseResponse apiResponse = await data.save();
  //   if (apiResponse.success && apiResponse.results != null) {
  //       return true;
  //       } else {
  //       return false;
  //     }
  // }

// Ride functions start
  Future getRides(String? srchTxt) async {
    final ParseCloudFunction function = ParseCloudFunction("getRides");
    final Map<String, dynamic> params = <String, dynamic>{'srchTxt': srchTxt};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    // print(parseResponse.results);
    if (parseResponse.success && parseResponse.results != null) {
      return (parseResponse.results as List)[0]["result"];
    } else {
      return [];
    }
  }

  Future<List> getRidesADMIN(String uid) async {
    final ParseCloudFunction function = ParseCloudFunction("getRidesADMIN");
    final Map<String, dynamic> params = <String, dynamic>{'uid': uid};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.results != null) {
      return (parseResponse.results as List)[0]["result"] as List;
    } else {
      return [];
    }
  }

  Future<bool> setRide(RideModel model) async {
    final ParseCloudFunction function = ParseCloudFunction("setRide");
    final Map<String, dynamic> params = <String, dynamic>{
      'objectId': model.objectId,
      'uid': model.uid,
      'dttm': model.dttm,
      'from': model.from,
      'to': model.to,
      'message': model.message,
      'loadType': model.loadType,
      'status': model.status,
    };
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.result != null) {
      return true;
    }
    return false;
  }

  Future<bool> setRideADMIN(RideModel model) async {
    final ParseCloudFunction function = ParseCloudFunction("setRideADMIN");
    final Map<String, dynamic> params = <String, dynamic>{
      'objectId': model.objectId,
      'uid': model.uid,
      'dttm': model.dttm,
      'from': model.from,
      'to': model.to,
      'message': model.message,
      'loadType': model.loadType,
      'status': model.status,
    };
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.result != null) {
      return true;
    }
    return false;
  }

  getRide(String objectId) async {
    final ParseCloudFunction function;
    final Map<String, dynamic> params;
    function = ParseCloudFunction("getRide");
    params = <String, dynamic>{'objectId': objectId};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    // print(objectId);
    // print(parseResponse.results?[0]["result"]);
    if (parseResponse.success && parseResponse.results != null) {
      return parseResponse.results?[0]["result"];
    }
  }

  getRideADMIN(String objectId) async {
    final ParseCloudFunction function;
    final Map<String, dynamic> params;
    function = ParseCloudFunction("getRideADMIN");
    params = <String, dynamic>{'objectId': objectId};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    print(parseResponse.results?[0]["result"][0].objectId);
    if (parseResponse.success && parseResponse.result != null) {
      return parseResponse.results?[0]["result"];
    }
  }
// Ride functions end

  // Future<bool> setSettings(UserDataModel model) async {
  //   // TODO: Combine all Insert and Update method to Upsert
  //   // Refactor: all individual class updates to one dynamic function
  //   // aka pass class ID and model as params and use one generic function to upsert
  //   // see setData example mention earlier
  //   // this is why it's important to have Data model and From/TOJson factory methods to
  //   // serialze and deserialize json data feeds
  //   ParseObject data;
  //   if (model.objectId == "-") {
  //     data = ParseObject('Settings')
  //       // ..objectId = model.uid
  //       ..set('uid', model.uid)
  //       ..set('userName', model.userName)
  //       ..set('userType', model.userType)
  //       ..set('name', model.name)
  //       ..set('email', model.email)
  //       ..set('phone', model.phone)
  //       ..set('address', model.address);
  //   } else {
  //     data = ParseObject('Settings')
  //       ..objectId = model.objectId
  //       ..set('uid', model.uid)
  //       ..set('userName', model.userName)
  //       ..set('userType', model.userType)
  //       ..set('name', model.name)
  //       ..set('email', model.email)
  //       ..set('phone', model.phone)
  //       ..set('address', model.address);
  //   }
  //   final ParseResponse apiResponse = await data.save();
  //   if (apiResponse.success && apiResponse.results != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // message functions starts
  Future<List<ParseObject>> getMessages(String classId, String docId) async {
    // userID
    var username = await authBloc.getUser();
    var uid =
        (username?.get("objectId") == null) ? "-" : username?.get("objectId");

    QueryBuilder<ParseObject> parseQuery = QueryBuilder(ParseObject(classId));
    parseQuery.whereEqualTo('uid', uid);
    parseQuery.orderByDescending('createdAt');

    final ParseResponse apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<bool> setMessage(InboxModel model) async {
    ParseObject data;
    data = ParseObject('Messages')
      ..set('dttm', model.dttm)
      ..set('uid', model.uid)
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
  // message functions ends
}

final authBloc = AuthBloc();
