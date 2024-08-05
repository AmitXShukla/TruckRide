Clound functions
--------------
**Cloud function code**
// The example below shows you how a cloud code function looks like.

/* Parse Server 3.x
* Parse.Cloud.define("hello", (request) => {
* 	return("Hello world!");
* });
*/
Parse.Cloud.define('setUsersAcls', async(request) => {
  let currentUser = request.user;
  currentUser.setACL(new Parse.ACL(currentUser));
  return await currentUser.save(null, { useMasterKey: true });
});

// profile function start
Parse.Cloud.define("getProfile", async(request) => {
  let currentUser = request.user;
  let query = new Parse.Query("profile");
  query.equalTo("uid", currentUser.id);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;    
});
Parse.Cloud.define("getProfileADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("profile");
  query.equalTo("uid", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});
Parse.Cloud.define("setProfile", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  let userName = request.params.userName;
  let userType = request.params.userType;
  let name = request.params.name;
  let email = request.params.email;
  let phone = request.params.phone;
  let address = request.params.address;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("profile");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("profile");
    query.equalTo("uid", currentUser.id);
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", currentUser.id);
    todo.set("userName", userName);
    todo.set("userType", userType);
    todo.set("name", name);
    todo.set("email", email);
    todo.set("phone", phone);
    todo.set("address", address);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});

Parse.Cloud.define("getProfileADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("profile");
  query.equalTo("uid", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("setProfileADMIN", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  let uid = request.params.uid;
  let userName = request.params.userName;
  let userType = request.params.userType;
  let name = request.params.name;
  let email = request.params.email;
  let phone = request.params.phone;
  let address = request.params.address;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("profile");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("profile");
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", uid);
    todo.set("userName", userName);
    todo.set("userType", userType);
    todo.set("name", name);
    todo.set("email", email);
    todo.set("phone", phone);
    todo.set("address", address);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});
// profile function end

// ride functions start
Parse.Cloud.define("getRides", async(request) => {
  let currentUser = request.user;
  let srchTxt = request.params.srchTxt;
  let query = new Parse.Query("rides");
  query.descending("updatedAt");
  query.contains("from", srchTxt);
  query.contains("uid", currentUser.id);  
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getRidesADMIN", async(request) => {
  let currentUser = request.user;
  let uid = request.params.uid;
  let query = new Parse.Query("rides");
  query.descending("updatedAt");
  query.contains("uid", uid);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});


Parse.Cloud.define("getRideADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("rides");
  query.equalTo("objectId", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});


Parse.Cloud.define("getRide", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;  
  let query = new Parse.Query("rides");
  query.equalTo("uid", currentUser.id);
  query.equalTo("objectId", objectId);  
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;    
});

Parse.Cloud.define("setRideADMIN", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  let uid = request.params.uid;
  let dttm = request.params.dttm;
  let from = request.params.from;
  let to = request.params.to;
  let message = request.params.message;
  let loadType = request.params.loadType;
  let status = request.params.status;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("rides");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("rides");
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", uid);
    todo.set("dttm", dttm);
    todo.set("from", from);
    todo.set("to", to);
    todo.set("message", message);
    todo.set("loadType", loadType);
    todo.set("status", status);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});

Parse.Cloud.define("setRide", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  // let uid = request.params.uid;
  let dttm = request.params.dttm;
  let from = request.params.from;
  let to = request.params.to;
  let message = request.params.message;
  let loadType = request.params.loadType;
  let status = request.params.status;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("rides");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("rides");
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", currentUser.id);
    todo.set("dttm", dttm);
    todo.set("from", from);
    todo.set("to", to);
    todo.set("message", message);
    todo.set("loadType", loadType);
    todo.set("status", status);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});
// ride function ends

// document function start
Parse.Cloud.define("setDocs", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;
  let docId = request.params.docId; 
  let file = request.params.file;
  let ToDo = Parse.Object.extend("docs");
  let todo = new ToDo();
  todo.set("uid", currentUser.id);
  todo.set("docType", docType);
  todo.set("docId", docId);
  todo.set("file", file);
  return await todo.save(null, { useMasterKey: true });
});

Parse.Cloud.define("getDocs", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;
  let docId = request.params.docId;
  let query = new Parse.Query("docs");
  query.equalTo("uid", currentUser.id);
  query.equalTo("docType", docType);
  query.equalTo("docId", docId);
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
    return results;
});

Parse.Cloud.define("setDocsADMIN", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;
  let docId = request.params.docId;  
  let uid = request.params.uid;
  let file = request.params.file;
  let ToDo = Parse.Object.extend("docs");
  let todo = new ToDo();
  todo.set("uid", uid);
  todo.set("docType", docType);
  todo.set("docId", docId);  
  todo.set("file", file);
  return await todo.save(null, { useMasterKey: true });
});

Parse.Cloud.define("getDocsADMIN", async(request) => {
  let currentUser = request.user;
  let uid = request.params.uid;
  let docType = request.params.docType;
  let docId = request.params.docId;  
  let query = new Parse.Query("docs");
  query.equalTo("uid", uid);
  query.equalTo("docType", docType);
  query.equalTo("docId", docId);
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;  
});
// document function end

Parse.Cloud.define("getUserListADMIN", async(request) => {
  let currentUser = request.user;
  let username = request.params.username;
  let query = new Parse.Query("_User");
  query.descending("updatedAt");
  query.contains("username", username);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getUserRidesADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("Rides");
  query.equalTo("uid", objectId);
  query.limit(10);  
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("setUserFileDoc", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;
  let file = request.params.file;
  let ToDo = Parse.Object.extend("Gallery");
  let todo = new ToDo();
  todo.set("user", currentUser);
  todo.set("uid", currentUser.id);
  todo.set("docType", docType);  
  todo.set("file", file);
  return await todo.save(null, { useMasterKey: true });
});

Parse.Cloud.define("getUserFileDoc", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;  
  let query = new Parse.Query("Gallery");
  query.equalTo("user", currentUser);
  query.equalTo("docType", docType);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;  
});

Parse.Cloud.define("getUserSettingsDoc", async(request) => {
  let currentUser = request.user;
  let query = new Parse.Query("Settings");
  query.equalTo("user", currentUser);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;    
});

Parse.Cloud.define("setUserSettingsDoc", async(request) => {
  let currentUser = request.user;
  let userName = request.params.userName;
  let userType = request.params.userType;
  let name = request.params.name;
  let email = request.params.email;
  let phone = request.params.phone;
  let address = request.params.address;  
  let ToDo = Parse.Object.extend("Settings");
  let todo = new ToDo();
  todo.set("user", currentUser);
  todo.set("uid", currentUser.id);
  todo.set("userName", userName);
  todo.set("userType", userType);
  todo.set("name", name);
  todo.set("email", email);
  todo.set("phone", phone);
  todo.set("address", address);
  return await todo.save(null, { useMasterKey: true });
});

Parse.Cloud.define("updateUserSettingsDoc", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;  
  let userName = request.params.userName;
  let userType = request.params.userType;
  let name = request.params.name;
  let email = request.params.email;
  let phone = request.params.phone;
  let address = request.params.address;  

  let query = new Parse.Query("Settings");
  query.equalTo("user", currentUser);
  query.equalTo("objectId", todoId);
  let todo = await query.first({ useMasterKey: true });
  if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  todo.set("user", currentUser);
  todo.set("uid", currentUser.id);
  todo.set("userName", userName);
  todo.set("userType", userType);
  todo.set("name", name);
  todo.set("email", email);
  todo.set("phone", phone);
  todo.set("address", address);
  // return await todo.save(null, { useMasterKey: true });
  try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});

// Parse.Cloud.define("setUserSettingsDoc", async(request) => {
//   let currentUser = request.user;  
//   let query = new Parse.Query("settings");
//   query.equalTo("objectId", currentUser.id);
//   query.limit(1);
  
//   let results = await query.find({ useMasterKey: true });
//   if(results.length === 0) throw new Error('No results found!');
//       return results;
// });

Parse.Cloud.define("getUserSettingsDocADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("Settings");
  query.equalTo("uid", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getUserRideDocADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("Rides");
  query.equalTo("objectId", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("updateUserSettingsDocADMIN", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  let userName = request.params.userName;
  let userType = request.params.userType;
  let name = request.params.name;
  let email = request.params.email;
  let phone = request.params.phone;
  let address = request.params.address;  

  let query = new Parse.Query("Settings");
  query.equalTo("objectId", todoId);
  let todo = await query.first({ useMasterKey: true });
  if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  todo.set("userName", userName);
  todo.set("userType", userType);
  todo.set("name", name);
  todo.set("email", email);
  todo.set("phone", phone);
  todo.set("address", address);
  // return await todo.save(null, { useMasterKey: true });
  try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});

/* Parse Server 2.x
* Parse.Cloud.define("hello", function(request, response){
* 	response.success("Hello world!");
* });
*/

// To see it working, you only need to call it through SDK or REST API.
// Here is how you have to call it via REST API:

/** curl -X POST \
* -H "X-Parse-Application-Id: WrvzAjowhrUSgve8M5ldnC9vGDGgsX20yV1J3OxQ" \
* -H "X-Parse-REST-API-Key: gRQAcJyxXLEYzmiUVkMOUF7QrwLpEHtWaCqsdH8f" \
* -H "Content-Type: application/json" \
* -d "{}" \
* https://parseapi.back4app.com/functions/hello
*/

// If you have set a function in another cloud code file, called "test.js" (for example)
// you need to refer it in your main.js, as you can see below:

/* require("./test.js"); */
--------------
check getRide, getRidesADMIN if these two have proper uid where clause
search on biddable rides

Parse.Cloud.define("getBids", async(request) => {
  let currentUser = request.user;
  let srchTxt = request.params.srchTxt;
  let query = new Parse.Query("bids");
  query.descending("updatedAt");
  query.contains("from", srchTxt);
  parseQuery.equalTo('uid', currentUser.id);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getBidsADMIN", async(request) => {
  let currentUser = request.user;
  let srchTxt = request.params.srchTxt;
  let uid = request.params.uid;
  let query = new Parse.Query("bids");
  query.descending("updatedAt");
  query.equalTo("uid", uid);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getBiddableRides", async(request) => {
  let currentUser = request.user;
  let srchTxt = request.params.srchTxt;
  let query = new Parse.Query("bids");
  query.descending("updatedAt");
  query.contains("from", srchTxt);
  query.equalTo('status', "new");
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getBidsforRide", async(request) => {
  let currentUser = request.user;
  let rideId = request.params.rideId;
  let query = new Parse.Query("bids");
  query.descending("updatedAt");
  query.equalTo("rideId", rideId);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getBid", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("bids");
  query.descending("updatedAt");
  query.equalTo("objectId", objectId);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("setBid", async(request) => {
  
  ----------TODO
  -----------------
  
  let currentUser = request.user;
  let todoId = request.params.objectId;
  // let uid = request.params.uid;
  let dttm = request.params.dttm;
  let from = request.params.from;
  let to = request.params.to;
  let message = request.params.message;
  let loadType = request.params.loadType;
  let status = request.params.status;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("bids");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("rides");
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", currentUser.id);
    todo.set("dttm", dttm);
    todo.set("from", from);
    todo.set("to", to);
    todo.set("message", message);
    todo.set("loadType", loadType);
    todo.set("status", status);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});

Parse.Cloud.define("setBidADMIN", async(request) => {
  TODO
  ----
});


getBid

getBidsforRide

Future<List<ParseObject>> getBiddableRides(String classId) async {
  QueryBuilder<ParseObject> parseQuery = 
    QueryBuilder(ParseObject(classId));
    parseQuery.whereEqualTo('status', "new");
    parseQuery.setLimit(10);
    parseQuery.orderByDescending('createdAt');
  
  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
      } else {
        return [];
    }
}


getBids
getBidsforRide
getBiddableRide
setBid
getBid

getBidsADMIN
getBidsforRideADMIN
getBiddableRideADMIN
setBidADMIN
getBidADMIN


Parse.Cloud.define("getRides", async(request) => {
  let currentUser = request.user;
  let srchTxt = request.params.srchTxt;
  let query = new Parse.Query("rides");
  query.descending("updatedAt");
  query.contains("from", srchTxt);
  query.equalTo("uid", currentUser.id);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getRidesADMIN", async(request) => {
  let currentUser = request.user;
  let uid = request.params.uid;
  let query = new Parse.Query("rides");
  query.descending("updatedAt");
  query.equalTo("uid", uid);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});


Parse.Cloud.define("getRideADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("rides");
  query.equalTo("uid", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});


Parse.Cloud.define("getRide", async(request) => {
  let currentUser = request.user;
  let query = new Parse.Query("rides");
  query.equalTo("uid", currentUser.id);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;    
});

Parse.Cloud.define("setRideADMIN", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  let uid = request.params.uid;
  let dttm = request.params.dttm;
  let from = request.params.from;
  let to = request.params.to;
  let message = request.params.message;
  let loadType = request.params.loadType;
  let status = request.params.status;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("rides");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("rides");
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", uid);
    todo.set("dttm", dttm);
    todo.set("from", from);
    todo.set("to", to);
    todo.set("message", message);
    todo.set("loadType", loadType);
    todo.set("status", status);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});

Parse.Cloud.define("setRide", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  // let uid = request.params.uid;
  let dttm = request.params.dttm;
  let from = request.params.from;
  let to = request.params.to;
  let message = request.params.message;
  let loadType = request.params.loadType;
  let status = request.params.status;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("rides");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("rides");
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", currentUser.id);
    todo.set("dttm", dttm);
    todo.set("from", from);
    todo.set("to", to);
    todo.set("message", message);
    todo.set("loadType", loadType);
    todo.set("status", status);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});

setRide
getRides
getRide
setRideADMIN
getRidesADMIN
getRideADMIN

getOpenRides
setRideAdmin
get




profile
docs

Parse.Cloud.define("setDocs", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;
  let file = request.params.file;
  let ToDo = Parse.Object.extend("docs");
  let todo = new ToDo();
  todo.set("uid", currentUser.id);
  todo.set("docType", docType);  
  todo.set("file", file);
  return await todo.save(null, { useMasterKey: true });
});

Parse.Cloud.define("getDocs", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;  
  let query = new Parse.Query("docs");
  query.equalTo("uid", currentUser.id);
  query.equalTo("docType", docType);
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
    return results;
});

Parse.Cloud.define("setDocsADMIN", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;
  let uid = request.params.uid;
  let file = request.params.file;
  let ToDo = Parse.Object.extend("docs");
  let todo = new ToDo();
  todo.set("uid", uid);
  todo.set("docType", docType);  
  todo.set("file", file);
  return await todo.save(null, { useMasterKey: true });
});

Parse.Cloud.define("getDocsADMIN", async(request) => {
  let currentUser = request.user;
  let uid = request.params.uid;
  let docType = request.params.docType;  
  let query = new Parse.Query("docs");
  query.equalTo("uid", uid);
  query.equalTo("docType", docType);
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;  
});

Parse.Cloud.define("getProfileADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("profile");
  query.equalTo("uid", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});


Parse.Cloud.define("getProfile", async(request) => {
  let currentUser = request.user;
  let query = new Parse.Query("profile");
  query.equalTo("uid", currentUser.id);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;    
});

Parse.Cloud.define("setProfileADMIN", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  let uid = request.params.uid;
  let userName = request.params.userName;
  let userType = request.params.userType;
  let name = request.params.name;
  let email = request.params.email;
  let phone = request.params.phone;
  let address = request.params.address;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("profile");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("profile");
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", uid);
    todo.set("userName", userName);
    todo.set("userType", userType);
    todo.set("name", name);
    todo.set("email", email);
    todo.set("phone", phone);
    todo.set("address", address);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});

Parse.Cloud.define('setUsersAcls', async(request) => {
  let currentUser = request.user;
  currentUser.setACL(new Parse.ACL(currentUser));
  return await currentUser.save(null, { useMasterKey: true });
});

Parse.Cloud.define("getUserListADMIN", async(request) => {
  let currentUser = request.user;
  let username = request.params.username;
  let query = new Parse.Query("_User");
  query.descending("updatedAt");
  query.contains("username", username);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getUserRidesADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("Rides");
  query.equalTo("uid", objectId);
  query.limit(10);  
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("setUserFileDoc", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;
  let file = request.params.file;
  let ToDo = Parse.Object.extend("Gallery");
  let todo = new ToDo();
  todo.set("user", currentUser);
  todo.set("uid", currentUser.id);
  todo.set("docType", docType);  
  todo.set("file", file);
  return await todo.save(null, { useMasterKey: true });
});

Parse.Cloud.define("getUserFileDoc", async(request) => {
  let currentUser = request.user;
  let docType = request.params.docType;  
  let query = new Parse.Query("Gallery");
  query.equalTo("user", currentUser);
  query.equalTo("docType", docType);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;  
});

Parse.Cloud.define("getUserSettingsDoc", async(request) => {
  let currentUser = request.user;
  let query = new Parse.Query("Settings");
  query.equalTo("user", currentUser);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;    
});

Parse.Cloud.define("setUserSettingsDoc", async(request) => {
  let currentUser = request.user;
  let userName = request.params.userName;
  let userType = request.params.userType;
  let name = request.params.name;
  let email = request.params.email;
  let phone = request.params.phone;
  let address = request.params.address;  
  let ToDo = Parse.Object.extend("Settings");
  let todo = new ToDo();
  todo.set("user", currentUser);
  todo.set("uid", currentUser.id);
  todo.set("userName", userName);
  todo.set("userType", userType);
  todo.set("name", name);
  todo.set("email", email);
  todo.set("phone", phone);
  todo.set("address", address);
  return await todo.save(null, { useMasterKey: true });
});

Parse.Cloud.define("updateUserSettingsDoc", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;  
  let userName = request.params.userName;
  let userType = request.params.userType;
  let name = request.params.name;
  let email = request.params.email;
  let phone = request.params.phone;
  let address = request.params.address;  

  let query = new Parse.Query("Settings");
  query.equalTo("user", currentUser);
  query.equalTo("objectId", todoId);
  let todo = await query.first({ useMasterKey: true });
  if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  todo.set("user", currentUser);
  todo.set("uid", currentUser.id);
  todo.set("userName", userName);
  todo.set("userType", userType);
  todo.set("name", name);
  todo.set("email", email);
  todo.set("phone", phone);
  todo.set("address", address);
  // return await todo.save(null, { useMasterKey: true });
  try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});

// Parse.Cloud.define("setUserSettingsDoc", async(request) => {
//   let currentUser = request.user;  
//   let query = new Parse.Query("settings");
//   query.equalTo("objectId", currentUser.id);
//   query.limit(1);
  
//   let results = await query.find({ useMasterKey: true });
//   if(results.length === 0) throw new Error('No results found!');
//       return results;
// });

Parse.Cloud.define("getUserSettingsDocADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("Settings");
  query.equalTo("uid", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getUserRideDocADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("Rides");
  query.equalTo("objectId", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("updateUserSettingsDocADMIN", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  let userName = request.params.userName;
  let userType = request.params.userType;
  let name = request.params.name;
  let email = request.params.email;
  let phone = request.params.phone;
  let address = request.params.address;  

  let query = new Parse.Query("Settings");
  query.equalTo("objectId", todoId);
  let todo = await query.first({ useMasterKey: true });
  if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  todo.set("userName", userName);
  todo.set("userType", userType);
  todo.set("name", name);
  todo.set("email", email);
  todo.set("phone", phone);
  todo.set("address", address);
  // return await todo.save(null, { useMasterKey: true });
  try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});