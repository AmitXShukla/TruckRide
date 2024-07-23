import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../shared/constants.dart';
import '../../models/datamodel.dart';
import '../../models/validators.dart';
import '../../blocs/auth.bloc.dart';
import 'package:flutter/cupertino.dart';

import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

// ignore: must_be_immutable
class Admin extends StatefulWidget {
  static const routeName = '/admin';
  Admin(
      {super.key,
      required this.handleBrightnessChange,
      required this.setLocale});

  Function(bool useLightMode) handleBrightnessChange;
  Function(Locale _locale) setLocale;
  @override
  AdminState createState() => AdminState();
}

class AdminState extends State<Admin> {
  List res = [];
  bool isUserValid = true;
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  String srchUserName = "";

  @override
  void initState() {
    super.initState();
    loadAuthState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadAuthState() async {
    final userState = await authBloc.isSignedIn();
    setState(() => isUserValid = userState);
    getUserListADMIN("a");
  }

  toggleSpinner() {
    setState(() => spinnerVisible = !spinnerVisible);
  }

  showMessage(bool msgVisible, msgType, message) {
    messageVisible = msgVisible;
    setState(() {
      messageType = msgType == "error"
          ? cMessageType.error.toString()
          : cMessageType.success.toString();
      messageTxt = message;
    });
  }

  getUserListADMIN(String? srchTxt) async {
    toggleSpinner();
    final ParseCloudFunction function = ParseCloudFunction("getUserListADMIN");
    final Map<String, dynamic> params = <String, dynamic>{'username': srchTxt};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.results != null) {
      setState(() {
        res = (parseResponse.results as List)[0]["result"];
      });
    }
    toggleSpinner();
  }

  getUserSettingsDocADMIN(String objectId) async {
    toggleSpinner();
    final ParseCloudFunction function =
        ParseCloudFunction("getUserSettingsDocADMIN");
    final Map<String, dynamic> params = <String, dynamic>{'objectId': objectId};
    final ParseResponse parseResponse =
        await function.executeObjectFunction<ParseObject>(parameters: params);
    if (parseResponse.success && parseResponse.results != null) {
      setState(() {
        res = (parseResponse.results as List)[0]["result"];
      });
    }
    toggleSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createNavLogInBar(context, widget),
        body: Material(
            child: Container(
                margin: const EdgeInsets.all(20.0),
                child: (isUserValid == true)
                    ? userHistory(context)
                    : loginPage(context))));
  }

// user data table
  Widget userHistory(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Row(
                  children: [
                    Container(
                        width: 300.0,
                        margin: const EdgeInsets.only(top: 25.0),
                        child: TextFormField(
                          cursorColor: Colors.blueAccent,
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 50,
                          obscureText: false,
                          onChanged: (value) => srchUserName = value,
                          validator: (value) {
                            return Validators().evalChar(value!);
                          },
                          // onSaved: (value) => _email = value,
                          decoration: InputDecoration(
                            // icon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            hintText: 'emailID',
                            labelText: 'user name',
                            // errorText: snapshot.error,
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getUserListADMIN(srchUserName);
                      },
                      child: Icon(Icons.search, color: Colors.blueAccent),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const AddUser()),
                        );
                      },
                      child: const Icon(Icons.add, color: Colors.greenAccent),
                    ),
                  ],
                ),
                const Text(
                  "Admin",
                  style: cNavText,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "recent users",
                  style: cSuccessText,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'createdAt',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'updatedAt',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'user',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Action',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                    rows: res
                        .map(
                          (res) => DataRow(cells: [
                            DataCell(
                              Row(
                                children: [
                                  Text(
                                    res["createdAt"]
                                        .toString()
                                        .toString()
                                        .substring(
                                            0,
                                            min(
                                                10,
                                                res["updatedAt"]
                                                    .toString()
                                                    .length)),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                "${res["updatedAt"].toString().substring(0, min(19, res["updatedAt"].toString().length))}...",
                              ),
                            ),
                            DataCell(
                              Text(
                                "${res["username"]}",
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.orange,
                                    tooltip: 'Edit',
                                    onPressed: () {
                                      showUserSettings(context, res);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.bus_alert),
                                    color:
                                        const Color.fromARGB(255, 178, 124, 52),
                                    tooltip: 'Rides',
                                    // onPressed: () {
                                    //   showAlertDialog1(context, res);
                                    // },
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => showUserRides(
                                                  docId: res["objectId"],
                                                )),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.fire_truck),
                                    color: Colors.brown,
                                    tooltip: 'Bids',
                                    // onPressed: () {
                                    //   showAlertDialog1(context, res);
                                    // },
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => showUserRides(
                                                  docId: res["objectId"],
                                                )),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.business_center),
                                    color:
                                        const Color.fromARGB(255, 178, 124, 52),
                                    tooltip: 'Orders',
                                    // onPressed: () {
                                    //   showAlertDialog1(context, res);
                                    // },
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/bids',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ]),
                        )
                        .toList(),
                  ),
                ),
                res.isEmpty ? const Text("no users found.") : const Text(""),
              ],
            ),
          ),
        ),
      ],
    );
  }

//login page - user not signed in
  Widget loginPage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
              label: Text("please Login again, you are currently signed out.",
                  style: cErrorText)),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('Login'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }

// display user settings
  showUserSettings(BuildContext context, res) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("edit user"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => EditUserSettings(
                    docId: res["objectId"],
                  )),
        );
      },
    );
    Widget continueButton = TextButton(
      child: const Text("ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(res["username"].toString()),
      content: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "username : ",
                  style: cNavText,
                ),
                Flexible(child: Text(res['username'].toString())),
              ],
            ),
            Row(
              children: [
                const Text(
                  "CreatedAt : ",
                  style: cNavText,
                ),
                Flexible(child: Text(res['createdAt'].toString())),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Last Updated : ",
                  style: cNavText,
                ),
                Flexible(child: Text(res['updatedAt'].toString())),
              ],
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

// Edit Ride class code
class EditBid extends StatefulWidget {
  final String docId;
  // const EditBid({super.key, required this.docID});
  // Function(bool useLightMode) handleBrightnessChange;
  const EditBid({super.key, required this.docId});
  @override
  EditBidState createState() => EditBidState();
}

// Edit Ride class state
class EditBidState extends State<EditBid> {
  bool isUserValid = true;
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool _btnEnabled = false;
  bool _cancelEnabled = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  BidModel model = BidModel(
      objectId: '-',
      rideId: '-',
      rideDttm: '-',
      uid: '-',
      driver: '-',
      from: '-',
      to: '-',
      status: 'new',
      fileURL: '-',
      bid: '-',
      message: '-');
  InboxModel msgModel = InboxModel(
      dttm: '-',
      uid: '-',
      to: '-',
      message: '-',
      readReceipt: false,
      fileURL: '-');
  final TextEditingController _bidController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    loadAuthState();
    super.initState();
  }

  void loadAuthState() async {
    // storing user uid/objectId from users class, as a field into message record
    var username = await authBloc.getUser();
    final userState = await authBloc.isSignedIn();
    setState(() => isUserValid = userState);
    final userData = await authBloc.getBidDoc("Bids", widget.docId);

    if (userData.isNotEmpty) {
      setState(() {
        model.objectId = userData[0]["objectId"];
        model.rideId = userData[0]["objectId"];
        model.rideDttm = userData[0]["rideDttm"];
        model.uid = userData[0]["uid"];
        model.driver = (username?.get("objectId") == null)
            ? "-"
            : username?.get("objectId");
        model.from = userData[0]["from"];
        model.to = userData[0]["to"];
        model.status = "new";
        model.fileURL = userData[0]["fileURL"];
        model.bid = userData[0]["bid"];
        model.message = userData[0]["message"];

        _bidController.text = model.bid;
        _messageController.text = model.message;
      });
    }
  }

  @override
  void dispose() {
    _bidController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  toggleSpinner() {
    // TODO : refactor code
    //make this as a global reusable widget
    // define this in constants.dart
    setState(() => spinnerVisible = !spinnerVisible);
  }

  showMessage(bool msgVisible, msgType, message) {
    // TODO : refactor code
    //make this as a global reusable widget
    // define this in constants.dart
    messageVisible = msgVisible;
    setState(() {
      messageType = msgType == "error"
          ? cMessageType.error.toString()
          : cMessageType.success.toString();
      messageTxt = message;
    });
  }

  void setBid(BidModel model) async {
    toggleSpinner();
    // ignore: prefer_typing_uninitialized_variables
    var userData;
    userData = await authBloc.setBid("Bids", model);
    if (userData == true) {
      sendMessage(model.uid,
          "There is a bid update your ride, please check your rides.");
      sendMessage(model.driver, "You recently updated a bid on one ride.");
      showMessage(true, "success",
          "Bid is placed, please keep checking your Inbox for further notifications.");
    } else {
      showMessage(
          true, "error", "something went wrong, please contact your Admin.");
    }
    toggleSpinner();
  }

  void sendMessage(String recipient, String msg) async {
    msgModel.dttm = DateTime.now().toString();
    msgModel.uid = recipient;
    msgModel.to = "-";
    msgModel.message = msg;

    // ignore: prefer_typing_uninitialized_variables
    await authBloc.setMessage(msgModel);
  }

  @override
  Widget build(BuildContext context) {
    // AuthBloc authBloc = AuthBloc();
    return Scaffold(
        appBar: createCustomerNavBar(context, widget),
        body: Material(
            child: Container(
                margin: const EdgeInsets.all(20.0),
                child: (isUserValid == true)
                    ? userForm(context)
                    : loginPage(context))));
  }

// user form
  Widget userForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () =>
          setState(() => _btnEnabled = _formKey.currentState!.validate()),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              // const Image(image: AssetImage('../assets/afronalalogo.png'), width: 200, height: 200,),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    const Text(
                      "Edit Bid",
                      style: cBodyText,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: const Icon(Icons.info),
                      color: Colors.orangeAccent,
                      tooltip: 'Important',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Please make sure your driver informations is updated in your profile. Your customer will contact you only using your app email and phone number.')));
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/bids',
                          );
                        },
                        child: const Text('back')),
                  ],
                ),
              ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _bidController,
                    cursorColor: Colors.blueAccent,
                    // keyboardType: TextInputType.emailAddress,
                    maxLength: 30,
                    obscureText: false,
                    onChanged: (value) => model.bid = value,
                    validator: (value) {
                      return Validators().evalNumber(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.money),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'Price',
                      labelText: 'charges for service',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _messageController,
                    cursorColor: Colors.blueAccent,
                    // keyboardType: TextInputType.emailAddress,
                    maxLength: 100,
                    obscureText: false,
                    onChanged: (value) => model.message = value,
                    // validator: (value) {
                    //         // return Validators().evalEmail(value!);
                    // },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.message),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'type your message',
                      labelText: 'Message',
                      // errorText: snapshot.error,
                    ),
                  )),
              // Container(
              //   margin: const EdgeInsets.only(top: 5.0),
              // ),
              // Container(
              //   margin: const EdgeInsets.only(top: 5.0),
              // ),
              // const Text(
              //   "upload documents",
              //   style: cBodyText,
              // ),
              CustomSpinner(toggleSpinner: spinnerVisible, key: null),
              CustomMessage(
                toggleMessage: messageVisible,
                toggleMessageType: messageType,
                toggleMessageTxt: messageTxt,
                key: null,
              ),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              // signinSubmitBtn(context, authBloc),
              Column(
                children: [
                  // showAlertDialog3(context),
                  sendBtn(context),
                  const SizedBox(
                    width: 40,
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: CheckboxListTile(
                      value: _cancelEnabled,
                      onChanged: (newValue) =>
                          setState(() => _cancelEnabled = !_cancelEnabled),
                      title: const Text("cancel bid"),
                    ),
                  ),
                  cancelBtn(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//send button
  Widget sendBtn(context) {
    return ElevatedButton(
        onPressed: _btnEnabled == true ? () => setBid(model) : null,
        child: const Text('Update'));
  }

//cancel button
  Widget cancelBtn(context) {
    return ElevatedButton(
        onPressed: _cancelEnabled == true
            ? () {
                model.status = "cancelled";
                setBid(model);
              }
            : null,
        // onPressed: () {
        //   model.status = "cancelled";
        //   setRide(model);
        // },
        // _btnEnabled == true ? () => setRide(model) : null,
        child: const Text('Cancel Bid'));
  }

// cancel bid
  showAlertDialog3(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("cancel Bid"),
      onPressed: () {
        model.status = "cancelled";
        setBid(model);
        Navigator.pop(context);
        // Navigator.push(
        //       context,
        //       CupertinoPageRoute(builder: (context) => setRide(model)),
        //     );
      },
    );
    Widget continueButton = TextButton(
      child: const Text("close"),
      onPressed: () {
        // deleteData(res["objectId"]);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Please confirm"),
      content: const Text("do you really want to cancel this bid?"),
      actions: [cancelButton, continueButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//login page - user is not signed in
  Widget loginPage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
              label: Text("please Login again, you are currently signed out.",
                  style: cErrorText)),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('Login'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }
}

// Add User class
class AddUser extends StatefulWidget {
  const AddUser({super.key});
  @override
  AddUserState createState() => AddUserState();
}

class AddUserState extends State<AddUser> {
  bool isUserValid = false;
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool _btnEnabled = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  LoginDataModel model = LoginDataModel(
    email: 'noreply@duck.com',
    password: 'na',
  );
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    loadAuthState();
    super.initState();
  }

  void loadAuthState() async {
    final userState = await authBloc.isSignedIn();
    setState(() => isUserValid = userState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  toggleSpinner() {
    setState(() => spinnerVisible = !spinnerVisible);
  }

  showMessage(bool msgVisible, msgType, message) {
    messageVisible = msgVisible;
    setState(() {
      messageType = msgType == "error"
          ? cMessageType.error.toString()
          : cMessageType.success.toString();
      messageTxt = message;
    });
  }

  void setData(String loginType) async {
    toggleSpinner();
    // ignore: prefer_typing_uninitialized_variables
    var userAuth;
    userAuth = await authBloc.signUpWithEmail(model);

    if (userAuth.success) {
      showMessage(
          true, "success", "Account created, a welcome email is sent to user.");
    } else {
      showMessage(true, "error", userAuth.error!.message);
    }
    toggleSpinner();
  }

  @override
  Widget build(BuildContext context) {
    // AuthBloc authBloc = AuthBloc();
    return Scaffold(
        appBar: AppBar(
          title: const Text("create user"),
        ),
        body: Material(
            child: Container(
                margin: const EdgeInsets.all(20.0),
                child: (isUserValid == true)
                    ? userForm(context)
                    : loginPage(context))));
  }

// user form
  Widget userForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () =>
          setState(() => _btnEnabled = _formKey.currentState!.validate()),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const Image(
                image: AssetImage('../assets/afronalalogo.png'),
                width: 200,
                height: 200,
              ),
              // const Icon(Icons.electric_rickshaw_outlined,
              //                       color: Colors.greenAccent, size: 134),
              const SizedBox(
                width: 10,
                height: 20,
              ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _emailController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    onChanged: (value) => model.email = value,
                    validator: (value) {
                      return Validators().evalEmail(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'username@domain.com',
                      labelText: 'EmailID *',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _passwordController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 50,
                    obscureText: true,
                    onChanged: (value) => model.password = value,
                    validator: (value) {
                      return Validators().evalPassword(value!);
                    },
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'enter password',
                      labelText: 'Password *',
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 25.0),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              CustomSpinner(toggleSpinner: spinnerVisible, key: null),
              CustomMessage(
                toggleMessage: messageVisible,
                toggleMessageType: messageType,
                toggleMessageTxt: messageTxt,
                key: null,
              ),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              // signinSubmitBtn(context, authBloc),
              signinSubmitBtn(context),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signinSubmitBtn(context) {
    return ElevatedButton(
        onPressed: _btnEnabled == true ? () => setData("email") : null,
        child: const Text('create new user'));
  }

//login page - user is not signed in
  Widget loginPage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
              label: Text("please Login again, you are currently signed out.",
                  style: cErrorText)),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('Login'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }
}

class EditUserSettings extends StatefulWidget {
  final String docId;
  const EditUserSettings({super.key, required this.docId});
  @override
  EditUserSettingstate createState() => EditUserSettingstate();
}

class EditUserSettingstate extends State<EditUserSettings> {
  bool isUserValid = true;
  bool fileUpload = false;
  static List<String> list = <String>['Customer', 'Driver'];
  String dropdownValue = list.first;
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool _btnEnabled = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  var model = UserDataModel(
      objectId: '',
      uid: '',
      userName: '',
      userType: '',
      name: '',
      email: '',
      phone: '',
      address: '');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAuthState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void loadAuthState() async {
    toggleSpinner();
    final userState = await authBloc.isSignedIn();
    setState(() => isUserValid = userState);
    model.userType = dropdownValue;
    await authBloc.getUserSettingsDocADMIN(widget.docId).then((res) => {
          if (res != null)
            {
              setState(() {
                model.uid = res["uid"];
                model.objectId = res["objectId"];
                model.name = res["name"];
                _nameController.text = res["name"];
                model.email = res["email"];
                _emailController.text = res["email"];
                model.phone = res["phone"];
                _phoneController.text = res["phone"];
                model.address = res["address"];
                _addressController.text = res["address"];
                dropdownValue = res["userType"];
              })
            }
          else
            {
              setState(() {
                model.objectId = "-";
                model.uid = widget.docId;
              })
            }
        });
    if (model.objectId != "-") {
      setState(() {
        fileUpload = true;
      });
    }
    toggleSpinner();
  }

  toggleSpinner() {
    setState(() => spinnerVisible = !spinnerVisible);
  }

  showMessage(bool msgVisible, msgType, message) {
    messageVisible = msgVisible;
    setState(() {
      messageType = msgType == "error"
          ? cMessageType.error.toString()
          : cMessageType.success.toString();
      messageTxt = message;
    });
  }

  resetPassword() async {
    toggleSpinner();
    var val = await authBloc.resetPassword();
    if (val.success == true) {
      showMessage(true, "success",
          "Reset password email is sent to your registered email.");
    } else {
      showMessage(
          true, "error", "something went wrong, please contact your Admin.");
    }
    toggleSpinner();
  }

  void setData() async {
    toggleSpinner();
    // ignore: prefer_typing_uninitialized_variables
    var userData;
    model.userType = dropdownValue;
    userData = await authBloc.setUserSettingsDocADMIN(model);
    if (userData == true) {
      showMessage(true, "success", "user settings updated.");
      loadAuthState();
    } else {
      showMessage(
          true, "error", "something went wrong, please contact your Admin.");
    }
    toggleSpinner();
  }

  @override
  Widget build(BuildContext context) {
    // AuthBloc authBloc = AuthBloc();
    return Scaffold(
        appBar: AppBar(
          title: const Text("update user settings"),
        ),
        body: Material(
            child: Container(
                margin: const EdgeInsets.all(20.0),
                child: (isUserValid == true)
                    ? userForm(context)
                    : loginPage(context))));
  }

  Widget userForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () =>
          setState(() => _btnEnabled = _formKey.currentState!.validate()),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              // const Image(image: AssetImage('../assets/afronalalogo.png'), width: 200, height: 200,),
              const Text(
                "update settings",
                style: cBodyText,
              ),
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                // style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _nameController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    onChanged: (value) => model.name = value,
                    validator: (value) {
                      return Validators().evalName(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'Name',
                      labelText: 'Name *',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _emailController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    onChanged: (value) => model.email = value,
                    validator: (value) {
                      return Validators().evalEmail(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'emailID',
                      labelText: 'EmailID *',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _phoneController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    onChanged: (value) => model.phone = value,
                    validator: (value) {
                      return Validators().evalPhone(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'Phone #',
                      labelText: 'Phone *',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _addressController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    onChanged: (value) => model.address = value,
                    validator: (value) {
                      return Validators().evalChar(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.home_filled),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'Address #',
                      labelText: 'Address *',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              CustomSpinner(toggleSpinner: spinnerVisible, key: null),
              CustomMessage(
                toggleMessage: messageVisible,
                toggleMessageType: messageType,
                toggleMessageTxt: messageTxt,
                key: null,
              ),
              (fileUpload == true)
                  ? Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SavePage(docType: "docs", docId: model.uid, uid: model.uid)),
                              );
                            },
                            child: const Text("upload documents")),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DisplayPage(docType: "docs", docId: model.uid, uid: model.uid)),
                              );
                            },
                            child: const Text("display documents")),
                      ],
                    )
                  : const Text("save settings before file upload"),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              sendBtn(context),
              // model.objectId == "-"
              //     ? const Text(
              //         "no user data found",
              //         style: cErrorText,
              //       )
              //     : sendBtn(context),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              // ElevatedButton(
              //   child: const Text('reset password'),
              //   // color: Colors.blue,
              //   onPressed: () {
              //     showAlertDialog(context);
              //   },
              // ),
              // Container(
              //   margin: const EdgeInsets.only(top: 15.0),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sendBtn(context) {
    return ElevatedButton(
        onPressed: _btnEnabled == true ? () => setData() : null,
        child: const Text('save'));
  }

  Widget loginPage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
              label: Text("please Login again, you are currently signed out.",
                  style: cErrorText)),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('Login'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        resetPassword();
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Please confirm"),
      content: const Text("Would you like to continue with Reset Password ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

// Edit Ride class code
class EditRide extends StatefulWidget {
  final String docId;
  const EditRide({super.key, required this.docId});
  @override
  EditRideState createState() => EditRideState();
}

class EditRideState extends State<EditRide> {
  bool isUserValid = true;
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool _btnEnabled = false;
  bool _cancelEnabled = false;
  bool _completeEnabled = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  RideModel model = RideModel(
      objectId: '-',
      uid: '-',
      dttm: '-',
      from: '-',
      to: '-',
      message: '-',
      loadType: '-',
      status: 'new');
  InboxModel msgModel = InboxModel(
      dttm: '-',
      uid: '-',
      to: '-',
      message: '-',
      readReceipt: false,
      fileURL: '-');
  final TextEditingController _dttmController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _loadTypeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    loadAuthState();
    super.initState();
  }

  void loadAuthState() async {
    var username = await authBloc.getUser();
    await authBloc
        .isSignedIn()
        .then((userState) => {setState(() => isUserValid = userState)});

    // final userData = await authBloc.getDoc("Rides", widget.docId);
    final userData = await authBloc.getRideADMIN(widget.docId);
    if (userData != null) {
      setState(() {
        model.objectId = userData["objectId"];
        model.uid = (username?.get("objectId") == null)
            ? "-"
            : username?.get("objectId");
        model.dttm = userData["dttm"];
        model.from = userData["from"];
        model.to = userData["to"];
        model.message = userData["message"];
        model.loadType = userData["loadType"];
        model.status = userData["status"];

        _dttmController.text = model.dttm;
        _fromController.text = model.from;
        _toController.text = model.to;
        _loadTypeController.text = model.loadType;
        _messageController.text = model.message;
      });
    }
  }

  @override
  void dispose() {
    _dttmController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _loadTypeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  toggleSpinner() {
    setState(() => spinnerVisible = !spinnerVisible);
  }

  showMessage(bool msgVisible, msgType, message) {
    messageVisible = msgVisible;
    setState(() {
      messageType = msgType == "error"
          ? cMessageType.error.toString()
          : cMessageType.success.toString();
      messageTxt = message;
    });
  }

  void setRide(RideModel model) async {
    toggleSpinner();
    // ignore: prefer_typing_uninitialized_variables
    var userData;
    userData = await authBloc.setRide(model);
    if (userData == true) {
      sendMessage("Your recently updated your ride");
      showMessage(true, "success",
          "Ride is edited, please keep checking your Inbox for further notifications.");
    } else {
      showMessage(
          true, "error", "something went wrong, please contact your Admin.");
    }
    toggleSpinner();
  }

  void sendMessage(String msg) async {
    var username = await authBloc.getUser();
    // storing user uid/objectId from users class, as a field into message record
    msgModel.dttm = DateTime.now().toString();
    msgModel.uid =
        (username?.get("objectId") == null) ? "-" : username?.get("objectId");
    msgModel.to = "-";
    msgModel.message = msg;

    // ignore: prefer_typing_uninitialized_variables
    await authBloc.setMessage(msgModel);
  }

  @override
  Widget build(BuildContext context) {
    // AuthBloc authBloc = AuthBloc();
    return Scaffold(
        appBar: AppBar(
          title: Text("edit ride"),
        ),
        body: Material(
            child: Container(
                margin: const EdgeInsets.all(20.0),
                child: (isUserValid == true)
                    ? userForm(context)
                    : loginPage(context))));
  }

  Widget userForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () =>
          setState(() => _btnEnabled = _formKey.currentState!.validate()),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              // const Image(image: AssetImage('../assets/afronalalogo.png'), width: 200, height: 200,),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    const Text(
                      "Edit ride",
                      style: cBodyText,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      icon: const Icon(Icons.info),
                      color: Colors.orangeAccent,
                      tooltip: 'Important',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Please make sure your email, phone number is updated in your profile. Your provider will contact you only using your app email and phone number.')));
                      },
                    ),
                    // const SizedBox(
                    //   width: 5,
                    // ),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.pushNamed(
                    //         context,
                    //         '/rides',
                    //       );
                    //     },
                    //     child: const Text('back')),
                  ],
                ),
              ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _dttmController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.datetime,
                    maxLength: 100,
                    obscureText: false,
                    onChanged: (value) => model.dttm = value,
                    validator: (value) {
                      return Validators().evalDate(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.punch_clock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'mm/dd/yy',
                      labelText: 'Load Pick date time',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _fromController,
                    cursorColor: Colors.blueAccent,
                    // keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    onChanged: (value) => model.from = value,
                    validator: (value) {
                      return Validators().evalChar(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.business),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'Pickup Location',
                      labelText: 'Pickup Address',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _toController,
                    cursorColor: Colors.blueAccent,
                    // keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    onChanged: (value) => model.to = value,
                    validator: (value) {
                      return Validators().evalChar(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.house),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'Drop off Location',
                      labelText: 'Drop off Address',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _loadTypeController,
                    cursorColor: Colors.blueAccent,
                    // keyboardType: TextInputType.emailAddress,
                    maxLength: 30,
                    obscureText: false,
                    onChanged: (value) => model.loadType = value,
                    validator: (value) {
                      return Validators().evalChar(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.luggage),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'load dimensions',
                      labelText: 'Load Type',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _messageController,
                    cursorColor: Colors.blueAccent,
                    // keyboardType: TextInputType.emailAddress,
                    maxLength: 100,
                    obscureText: false,
                    onChanged: (value) => model.message = value,
                    // validator: (value) {
                    //         // return Validators().evalEmail(value!);
                    // },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.message),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'type your message',
                      labelText: 'Message',
                      // errorText: snapshot.error,
                    ),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              CustomSpinner(toggleSpinner: spinnerVisible, key: null),
              CustomMessage(
                toggleMessage: messageVisible,
                toggleMessageType: messageType,
                toggleMessageTxt: messageTxt,
                key: null,
              ),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              // signinSubmitBtn(context, authBloc),
              Column(
                children: [
                  // showAlertDialog3(context),
                  sendBtn(context),
                  const SizedBox(
                    width: 40,
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: CheckboxListTile(
                      value: _cancelEnabled,
                      onChanged: (newValue) =>
                          setState(() => _cancelEnabled = !_cancelEnabled),
                      title: const Text("cancel ride"),
                    ),
                  ),
                  cancelBtn(context),
                  SizedBox(
                    width: 200,
                    child: CheckboxListTile(
                      value: _completeEnabled,
                      onChanged: (newValue) =>
                          setState(() => _completeEnabled = !_completeEnabled),
                      title: const Text("complete ride"),
                    ),
                  ),
                  completeBtn(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sendBtn(context) {
    return ElevatedButton(
        onPressed: _btnEnabled == true ? () => setRide(model) : null,
        child: const Text('Update'));
  }

  Widget cancelBtn(context) {
    return ElevatedButton(
        onPressed: _cancelEnabled == true
            ? () {
                model.status = "cancelled";
                setRide(model);
                sendMessage("You recently cancelled your ride.");
              }
            : null,
        // onPressed: () {
        //   model.status = "cancelled";
        //   setRide(model);
        // },
        // _btnEnabled == true ? () => setRide(model) : null,
        child: const Text('Cancel Ride'));
  }

  Widget completeBtn(context) {
    return ElevatedButton(
        onPressed: _completeEnabled == true
            ? () {
                model.status = "complete";
                setRide(model);
                sendMessage("Your ride is marked complete now.");
              }
            : null,
        // onPressed: () {
        //   model.status = "cancelled";
        //   setRide(model);
        // },
        // _btnEnabled == true ? () => setRide(model) : null,
        child: const Text('Complete Ride'));
  }

  showAlertDialog3(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("cancel Ride"),
      onPressed: () {
        model.status = "cancelled";
        setRide(model);
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("close"),
      onPressed: () {
        // deleteData(res["objectId"]);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Please confirm"),
      content: const Text("do you really want to cancel this ride?"),
      actions: [cancelButton, continueButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget loginPage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
              label: Text("please Login again, you are currently signed out.",
                  style: cErrorText)),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('Login'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }
}

// Accept Bids class code
class AcceptBid extends StatefulWidget {
  final String docId;
  const AcceptBid({super.key, required this.docId});
  @override
  AcceptBidState createState() => AcceptBidState();
}

class AcceptBidState extends State<AcceptBid> {
  bool isUserValid = true;
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool _btnEnabled = false;
  bool _completeEnabled = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  RideModel rideModel = RideModel(
      objectId: '-',
      uid: '-',
      dttm: '-',
      from: '-',
      to: '-',
      message: '-',
      loadType: '-',
      status: 'new');
  BidModel bidModel = BidModel(
      objectId: '-',
      rideId: '-',
      rideDttm: '-',
      uid: '-',
      driver: '-',
      from: '-',
      to: '-',
      status: 'new',
      fileURL: '-',
      bid: '-',
      message: '-');
  InboxModel msgModel = InboxModel(
      dttm: '-',
      uid: '-',
      to: '-',
      message: '-',
      readReceipt: false,
      fileURL: '-');

  @override
  void initState() {
    loadAuthState();
    super.initState();
  }

  void loadAuthState() async {
    // storing user uid/objectId from users class, as a field into message record
    var username = await authBloc.getUser();
    // final userState = await authBloc.isSignedIn();
    // setState(() => isUserValid = userState);
    await authBloc
        .isSignedIn()
        .then((userState) => {setState(() => isUserValid = userState)});
    await authBloc.getDoc("Rides", widget.docId).then((rideData) => {
          if (rideData.isNotEmpty)
            {
              setState(() {
                rideModel.objectId = rideData[0]["objectId"];
                rideModel.uid = (username?.get("objectId") == null)
                    ? "-"
                    : username?.get("objectId");
                rideModel.dttm = rideData[0]["dttm"];
                rideModel.from = rideData[0]["from"];
                rideModel.to = rideData[0]["to"];
                rideModel.message = rideData[0]["message"];
                rideModel.loadType = rideData[0]["loadType"];
                rideModel.status = rideData[0]["status"];
              })
            }
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  toggleSpinner() {
    // TODO : refactor code
    //make this as a global reusable widget
    // define this in constants.dart
    setState(() => spinnerVisible = !spinnerVisible);
  }

  showMessage(bool msgVisible, msgType, message) {
    // TODO : refactor code
    //make this as a global reusable widget
    // define this in constants.dart
    messageVisible = msgVisible;
    setState(() {
      messageType = msgType == "error"
          ? cMessageType.error.toString()
          : cMessageType.success.toString();
      messageTxt = message;
    });
  }

  void setRide(RideModel model) async {
    toggleSpinner();
    // ignore: prefer_typing_uninitialized_variables
    var userData;
    userData = await authBloc.setRide(model);
    if (userData == true) {
      sendMessage("Your ride is confirmed.");
      showMessage(true, "success",
          "Ride is confirmed, please keep checking your Inbox for further notifications.");
    } else {
      showMessage(
          true, "error", "something went wrong, please contact your Admin.");
    }
    toggleSpinner();
  }

  void setBid(BidModel model) async {
    toggleSpinner();
    // ignore: prefer_typing_uninitialized_variables
    var userData;
    userData = await authBloc.setBid("Bide", model);
    if (userData == true) {
      sendMessage("Your Bid is accepted.");
      showMessage(true, "success",
          "Ride is confirmed, please keep checking your Inbox for further notifications.");
    } else {
      showMessage(
          true, "error", "something went wrong, please contact your Admin.");
    }
    toggleSpinner();
  }

  void sendMessage(String msg) async {
    var username = await authBloc.getUser();
    // storing user uid/objectId from users class, as a field into message record
    msgModel.dttm = DateTime.now().toString();
    msgModel.uid =
        (username?.get("objectId") == null) ? "-" : username?.get("objectId");
    msgModel.to = "-";
    msgModel.message = msg;

    // ignore: prefer_typing_uninitialized_variables
    await authBloc.setMessage(msgModel);
  }

  @override
  Widget build(BuildContext context) {
    // AuthBloc authBloc = AuthBloc();
    return Scaffold(
        appBar: createCustomerNavBar(context, widget),
        body: Material(
            child: Container(
                margin: const EdgeInsets.all(20.0),
                child: (isUserValid == true)
                    ? userForm(context)
                    : loginPage(context))));
  }

  Widget userForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () =>
          setState(() => _btnEnabled = _formKey.currentState!.validate()),
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: <Widget>[
                // const Image(image: AssetImage('../assets/afronalalogo.png'), width: 200, height: 200,),
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const Text(
                        "Bids",
                        style: cBodyText,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        icon: const Icon(Icons.info),
                        color: Colors.orangeAccent,
                        tooltip: 'Important',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  'Once your ride and bid is confirmed, your ride can not be changed.')));
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/rides',
                            );
                          },
                          child: const Text('back')),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "Ride Date : ",
                      style: cNavText,
                    ),
                    Flexible(child: Text(rideModel.dttm)),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "From : ",
                      style: cNavText,
                    ),
                    Flexible(child: Text(rideModel.from)),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "To : ",
                      style: cNavText,
                    ),
                    Flexible(child: Text(rideModel.to)),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Message : ",
                      style: cNavText,
                    ),
                    Flexible(child: Text(rideModel.message)),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Load Type : ",
                      style: cNavText,
                    ),
                    Flexible(child: Text(rideModel.loadType)),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Ride Status : ",
                      style: cNavText,
                    ),
                    Flexible(child: Text(rideModel.status)),
                  ],
                ),
                CustomSpinner(toggleSpinner: spinnerVisible, key: null),
                CustomMessage(
                  toggleMessage: messageVisible,
                  toggleMessageType: messageType,
                  toggleMessageTxt: messageTxt,
                  key: null,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15.0),
                ),
                // signinSubmitBtn(context, authBloc),
                Column(
                  children: [
                    SizedBox(
                      width: 200,
                      child: CheckboxListTile(
                        value: _completeEnabled,
                        onChanged: (newValue) => setState(
                            () => _completeEnabled = !_completeEnabled),
                        title: const Text("complete ride"),
                      ),
                    ),
                    completeBtn(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget completeBtn(context) {
    return ElevatedButton(
        onPressed: _completeEnabled == true
            ? () {
                rideModel.status = "complete";
                setRide(rideModel);
                sendMessage("Your ride is marked complete now.");
              }
            : null,
        // onPressed: () {
        //   model.status = "cancelled";
        //   setRide(model);
        // },
        // _btnEnabled == true ? () => setRide(model) : null,
        child: const Text('Complete Ride'));
  }

  Widget loginPage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
              label: Text("please Login again, you are currently signed out.",
                  style: cErrorText)),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('Login'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }
}

class showUserRides extends StatefulWidget {
  final String docId;
  const showUserRides({super.key, required this.docId});
  @override
  showUserRidesState createState() => showUserRidesState();
}

class showUserRidesState extends State<showUserRides> {
  // List<ParseObject> results = <ParseObject>[];
  // ignore: prefer_typing_uninitialized_variables
  List results = [];
  bool isUserValid = true;
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  InboxModel msgModel = InboxModel(
      dttm: '-',
      uid: '-',
      to: '-',
      message: '-',
      readReceipt: false,
      fileURL: '-');

  @override
  void initState() {
    super.initState();
    loadAuthState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadAuthState() async {
    final userState = await authBloc.isSignedIn();
    setState(() => isUserValid = userState);
    getData();
  }

  toggleSpinner() {
    setState(() => spinnerVisible = !spinnerVisible);
  }

  showMessage(bool msgVisible, msgType, message) {
    messageVisible = msgVisible;
    setState(() {
      messageType = msgType == "error"
          ? cMessageType.error.toString()
          : cMessageType.success.toString();
      messageTxt = message;
    });
  }

  getData() async {
    toggleSpinner();
    // var res = await authBloc.getUserRidesADMIN(widget.docId);
    var res = await authBloc.getRidesADMIN(widget.docId);
    setState(() {
      results = res;
    });
    toggleSpinner();
  }

  // deleteData(docID) async {
  //   await authBloc.delDoc("Rides", docID);
  //   sendMessage("Your deleted one of your rides.");
  //   getData();
  // }

  void sendMessage(String msg) async {
    // var username = await authBloc.getUser();
    // // storing user uid/objectId from users class, as a field into message record
    // msgModel.uid =
    //     (username?.get("objectId") == null) ? "-" : username?.get("objectId");
    await authBloc.getUser().then((username) => {
          msgModel.uid = (username?.get("objectId") == null)
              ? "-"
              : username?.get("objectId")
        });
    // storing user uid/objectId from users class, as a field into message record
    msgModel.dttm = DateTime.now().toString();
    msgModel.to = "-";
    msgModel.message = msg;

    // ignore: prefer_typing_uninitialized_variables
    await authBloc.setMessage(msgModel);
  }

  @override
  Widget build(BuildContext context) {
    // AuthBloc authBloc = AuthBloc();
    return Scaffold(
        appBar: AppBar(
          title: Text("user rides"),
        ),
        body: Material(
            child: Container(
                margin: const EdgeInsets.all(20.0),
                child: (isUserValid == true)
                    ? rideHistory(context)
                    : loginPage(context))));
  }

  Widget rideHistory(BuildContext context) {
    return CustomScrollView(
      // scrollDirection: Axis.vertical,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/ride',
                    );
                  },
                  child: const Chip(
                      backgroundColor: Colors.brown,
                      // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      )),
                      label: Text("Request a new ride")),
                ),
                const Text(
                  "recent rides",
                  style: cSuccessText,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'RideID',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Date',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'From',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'To',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Status',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Action',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                    rows: results
                        .map(
                          (res) => DataRow(cells: [
                            DataCell(
                              Row(
                                children: [
                                  Text(
                                    res["dttm"].toString().substring(0, 2)+res["objectId"].toString().substring(0, 3),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  Text(
                                    res["dttm"].toString(),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                "${res["from"].toString().substring(0, min(14, res["from"].toString().length))}...",
                              ),
                            ),
                            DataCell(
                              Text(
                                "${res["to"].toString().substring(0, min(14, res["to"].toString().length))}...",
                              ),
                            ),
                            DataCell(
                              Text(
                                res["status"],
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.fire_truck),
                                    color: Colors.brown,
                                    tooltip: 'Bids',
                                    // onPressed: () {
                                    //   // showAlertDialogBids(context);
                                    // },
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => AcceptBid(
                                                  docId: res["objectId"],
                                                )),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.orangeAccent,
                                    tooltip: 'Edit',
                                    onPressed: () {
                                      showAlertDialogEdit(context, res);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.upload_file),
                                    color: Colors.orangeAccent,
                                    tooltip: 'upload pics',
                                    onPressed: () {
                                                Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SavePage(docType: "ride", docId: res["objectId"], uid: res["uid"])),
          );
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.download),
                                    color: Colors.orangeAccent,
                                    tooltip: 'view pics',
                                    onPressed: () {
                                      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DisplayPage(docType: "ride", docId: res["objectId"], uid: res["uid"])),
      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ]),
                        )
                        .toList(),
                  ),
                ),
                results.isEmpty
                    ? const Text("no rides data found.")
                    : const Text(""),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget loginPage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
              ),
              label: Text("please Login again, you are currently signed out.",
                  style: cErrorText)),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('Login'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }

  showAlertDialogEdit(BuildContext context, res) {
    // set up the buttons
    Widget editButton = TextButton(
      child: const Text("Edit Ride"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => EditRide(
                    docId: res["objectId"],
                  )),
        );
      },
    );
    Widget infoButton = TextButton(
      child: Text(res['status']),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(res["dttm"].toString()),
      content: SizedBox(
        width: 400,
        height: 300,
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "From : ",
                  style: cNavText,
                ),
                Flexible(child: Text(res['from'].toString())),
              ],
            ),
            Row(
              children: [
                const Text(
                  "To : ",
                  style: cNavText,
                ),
                Flexible(child: Text(res['to'].toString())),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Message : ",
                  style: cNavText,
                ),
                Flexible(child: Text(res['message'].toString())),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Load Type : ",
                  style: cNavText,
                ),
                Text(res['loadType'].toString()),
              ],
            ),
            Row(
              children: [
                const Text(
                  "status : ",
                  style: cNavText,
                ),
                Text(res['status'].toString()),
              ],
            ),
          ],
        ),
      ),
      actions: [
        ((res["status"].toString() == "new") |
                (res["status"].toString() == "-"))
            ? editButton
            : infoButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class SavePage extends StatefulWidget {
  final String uid;
  final String docId;
  final String docType;
  const SavePage({super.key,  required this.docType, required this.docId, required this.uid});
  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  PickedFile? pickedFile;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('upload documents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              child: pickedFile != null
                  ? Container(
                      width: 250,
                      height: 250,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: kIsWeb
                          ? Image.network(pickedFile!.path)
                          : Image.file(File(pickedFile!.path)))
                  : Container(
                      width: 250,
                      height: 250,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: const Center(
                        child: Text('Click here to pick image from Gallery'),
                      ),
                    ),
              onTap: () async {
                // PickedFile? image =
                // var image =
                //      await ImagePicker().pickImage(source: ImageSource.gallery);
                var image2 =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                PickedFile? image = PickedFile(image2!.path);
                if (image != null) {
                  setState(() {
                    pickedFile = image;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Container(
                height: 50,
                child: ElevatedButton(
                  child: Text('Upload file'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: isLoading || pickedFile == null
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          ParseFileBase? parseFile;

                          if (kIsWeb) {
                            //Flutter Web
                            parseFile = ParseWebFile(
                                await pickedFile!.readAsBytes(),
                                name: 'image.jpg'); //Name for file is required
                          } else {
                            //Flutter Mobile/Desktop
                            parseFile = ParseFile(File(pickedFile!.path));
                          }
                          await parseFile.save();

                          //  final gallery = ParseObject('Gallery')
                          //    ..set('file', parseFile);
                          //  await gallery.save();
                          final gallery = await authBloc.setUserFileDocADMIN(
                              widget.docType, widget.docId, widget.uid, parseFile);
                          //  await gallery.save();
                          if (gallery) {
                            setState(() {
                              isLoading = false;
                              pickedFile = null;
                            });
                          }

                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                              content: Text(
                                'Save file with success on Back4app',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.blue,
                            ));
                        },
                ))
          ],
        ),
      ),
    );
  }
}

class DisplayPage extends StatefulWidget {
  final String uid;
  final String docId;
  final String docType;
  const DisplayPage({super.key,  required this.docType, required this.docId, required this.uid});
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Display Gallery"),
      ),
      body: FutureBuilder<List>(
          future: authBloc.getGalleryListADMIN(widget.docType, widget.docId, widget.uid),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator()),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error..."),
                  );
                } else {
                  return ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        //Web/Mobile/Desktop
                        ParseFileBase? varFile =
                            snapshot.data![index].get<ParseFileBase>('file');
                        //Only iOS/Android/Desktop
                        /*
                         ParseFile? varFile =
                             snapshot.data![index].get<ParseFile>('file');
                         */
                        return Image.network(
                          varFile!.url!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.fitHeight,
                        );
                      });
                }
            }
          }),
    );
  }
}
