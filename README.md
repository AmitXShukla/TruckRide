# TruckRide
Flutter Truck Ride Management app

**work in progress** `do not download`

## Truck Load Ride App

A free download to build a complete Truck/Services ride app.

## Author: Amit Shukla

## Connect

[<img src="https://github.com/AmitXShukla/AmitXShukla.github.io/blob/master/assets/icons/youtube.svg" width=40 height=50>](https://youtube.com/@Amit.Shukla)
[<img src="https://github.com/AmitXShukla/AmitXShukla.github.io/blob/master/assets/icons/github.svg" width=40 height=50>](https://github.com/AmitXShukla)
[<img src="https://github.com/AmitXShukla/AmitXShukla.github.io/blob/master/assets/icons/medium.svg" width=40 height=50>](https://medium.com/@Amit-Shukla)
[<img src="https://github.com/AmitXShukla/AmitXShukla.github.io/blob/master/assets/icons/twitter_1.svg" width=40 height=50>](https://twitter.com/ashuklax)

---
## [Video Tutorials](https://youtube.com/@Amit.Shukla)
---

## License Agreement

[License Information](https://github.com/AmitXShukla/GenAI/blob/master/LICENSE)

## Privacy Policy

[Privacy Policy](https://github.com/AmitXShukla/GenAI/blob/master/LICENSE)


## Recently completed
- rides - search filter     COMPLETE

## TODO

- bids - serach filter
- accept bids, close ride, close bids, create contract

- notifications
    - bids updated, created
    - rides updated, created
    - contracts updated, created

Admin to perform entire operations
- rides - search filter 
- bids - serach filter
- accept bids, close ride, close bids, create contract

- Multiligual
- admin reports

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

// bid functions start
Parse.Cloud.define("getBiddableRides", async(request) => {
  let currentUser = request.user;
  let srchTxt = request.params.srchTxt;
  let query = new Parse.Query("rides");
  query.descending("updatedAt");
  query.equalTo("status", "new");
  query.contains("from", srchTxt);
  query.contains("uid", currentUser.id);  
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getBids", async(request) => {
  let currentUser = request.user;
  let srchTxt = request.params.srchTxt;
  let query = new Parse.Query("bids");
  query.descending("updatedAt");
  query.contains("from", srchTxt);
  query.contains("uid", currentUser.id);  
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getBidsADMIN", async(request) => {
  let currentUser = request.user;
  let uid = request.params.uid;
  let query = new Parse.Query("bids");
  query.descending("updatedAt");
  query.contains("uid", uid);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getBidsForRide", async(request) => {
  let currentUser = request.user;
  let rideId = request.params.rideId;
  let query = new Parse.Query("bids");
  query.descending("updatedAt");
  query.equalTo("rideId", rideId);
  query.limit(10);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getBidADMIN", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;
  let query = new Parse.Query("bids");
  query.equalTo("objectId", objectId);
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;
});

Parse.Cloud.define("getBid", async(request) => {
  let currentUser = request.user;
  let objectId = request.params.objectId;  
  let query = new Parse.Query("bids");
  query.equalTo("uid", currentUser.id);
  query.equalTo("objectId", objectId);  
  query.limit(1);
  
  let results = await query.find({ useMasterKey: true });
  if(results.length === 0) throw new Error('No results found!');
      return results;    
});

Parse.Cloud.define("setBid", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  // let uid = request.params.uid;
  let rideId = request.params.rideId;
  let rideDttm = request.params.rideDttm;
  let driver = request.params.driver;
  let from = request.params.from;
  let to = request.params.to;
  let status = request.params.status;
  let fileURL = request.params.fileURL;
  let bid = request.params.bid;
  let message = request.params.message;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("bids");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("bids");
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", currentUser.id);
    todo.set("rideId", rideId);
    todo.set("rideDttm", rideDttm);
    todo.set("driver", driver);
    todo.set("from", from);
    todo.set("to", to);
    todo.set("status", status);
    todo.set("fileURL", fileURL);
    todo.set("bid", bid);
    todo.set("message", message);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});
Parse.Cloud.define("setBidADMIN", async(request) => {
  let currentUser = request.user;
  let todoId = request.params.objectId;
  let uid = request.params.uid;
  let rideId = request.params.rideId;
  let rideDttm = request.params.rideDttm;
  let driver = request.params.driver;
  let from = request.params.from;
  let to = request.params.to;
  let status = request.params.status;
  let fileURL = request.params.fileURL;
  let bid = request.params.bid;
  let message = request.params.message;
  let todo;
  if (todoId == "-") {
    let ToDo = Parse.Object.extend("bids");
    todo = new ToDo();
  } else {
    let query = new Parse.Query("bids");
    query.equalTo("objectId", todoId);
    todo = await query.first({ useMasterKey: true });
    if(Object.keys(todo).length === 0)  throw new Error('No results found!');
  }
    todo.set("uid", uid);
    todo.set("rideId", rideId);
    todo.set("rideDttm", rideDttm);
    todo.set("driver", driver);
    todo.set("from", from);
    todo.set("to", to);
    todo.set("status", status);
    todo.set("fileURL", fileURL);
    todo.set("bid", bid);
    todo.set("message", message);
    try {
      await todo.save(null, { useMasterKey: true}); 
        return todo;   
      } catch (error){
        return("getNewStore - Error - " + error.code + " " + error.message);
      }
});
// bid functions end

Amit fixed
- on every ride, new message, new notifiction, new email - working
max limit < 2MB
number of images 5
png, jpeg
gif (don't allow)

once a ride is closed, icon turns grey  (use traffic light colors instead)
once a ride is under contract, icon turns blue (use traffic light colors instead)

once a bid is closed, icon turns grey (use traffic light colors instead)
once a bid is under contract, icon turns blue (use traffic light colors instead)



Phase -2
phone - Text SMS

Daniel, Btsu send me
- date format (default date)
- load types (small, medium and large)
- message type


write text (1-2 lines) about contract
- Hey rider, once you accept this bid, you will get into a contract with driver,
you will still be able to change this contract in less than 48 hours of proposed ride date.
after 48 hours, you will have to deliver upto 20% of cancellation charges in case you cancel your ride.

- Hey Driver, once you accept this bid, you will get into a contract with rider,
you will still be able to change this contract in less than 48 hours of proposed ride date.
after 48 hours, you will have to deliver upto 20% of cancellation charges in case you cancel your ride.

your bid is succesffully place, you will be notified through email only if the customer accepted your bid.

Amit to fix
-------------
1. how many times a driver is allowed to bid? is there any limit? - make it one time bidding
2. message, notificaiton - split it to show rides, bids and generic message
3. for bid, ride and contract messages, make those email in BOLD RED
4. contract is a separate page
5. multi language
6. images - 5 MB limit - auto change image quality, don't upload 1 GB
7 - Using cloud functions and Twilio API to send Text Message - Daniel to research - API