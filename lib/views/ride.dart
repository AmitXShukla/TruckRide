import 'package:flutter/material.dart';
import '../shared/constants.dart';
import '../models/datamodel.dart';
import '../models/validators.dart';
import '../blocs/auth.bloc.dart';

// ignore: must_be_immutable
class Ride extends StatefulWidget {
  static const routeName = '/ride';
  Ride({super.key,
  required this.handleBrightnessChange});

  Function(bool useLightMode) handleBrightnessChange;
  @override
  RideState createState() => RideState();
}

class RideState extends State<Ride> {
  bool isUserValid = true;
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool _btnEnabled = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  RideModel model = RideModel(
              objectId: '-',
              requestor: '-',
              dttm: '-', from: '-', to: '-', message: '-', 
              loadType: '-', status: '-', fileURL: '-');
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
    final userState = await authBloc.isSignedIn();
    setState(() => isUserValid = userState);
    var username = await authBloc.getUser();
    // storing user uid/objectId from users class, as a field into message record
    model.dttm = DateTime.now().toString();
    model.requestor = (username?.get("objectId") ==  null) ? "-" : username?.get("objectId");
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
    userData = await authBloc.setRide("Rides", model);
    if (userData == true) {
      showMessage(true, "success", "Ride is booked, please keep checking your Inbox for further notifications.");
    } else {
      showMessage(true, "error", "something went wrong, please contact your Admin.");
    }
    toggleSpinner();
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
                  : loginPage(context)))
    );
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
                    const Text("Request a new ride", style: cBodyText,),
                    const SizedBox(width: 10,),
                    IconButton(
                      icon: const Icon(Icons.info),
                      color: Colors.orangeAccent,
                      tooltip: 'Important',
                      onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please make sure your email, phone number is updated in your profile. Your provider will contact you only using your app email and phone number.')));
                      },
                      ),
                      const SizedBox(width: 5,),
                    ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                      context,
                      '/rides',
                    );
                  },
                          child: const Text('back')
                        ),
                  ],
                ),
              ),
              // Container(
              //     width: 300.0,
              //     margin: const EdgeInsets.only(top: 25.0),
              //     child: TextFormField(
              //       // controller: _emailController,
              //       cursorColor: Colors.blueAccent,
              //       keyboardType: TextInputType.emailAddress,
              //       maxLength: 50,
              //       obscureText: false,
              //       // onChanged: (value) => model.email = value,
              //       validator: (value) {
              //               return Validators().evalEmail(value!);
              //       },
              //       // onSaved: (value) => _email = value,
              //       decoration: InputDecoration(
              //         icon: const Icon(Icons.person),
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(16.0)),
              //         hintText: 'Name',
              //         labelText: 'Name *',
              //         // errorText: snapshot.error,
              //       ),
              //     )),
              // Container(
              //   margin: const EdgeInsets.only(top: 5.0),
              // ),
              // Container(
              //     width: 300.0,
              //     margin: const EdgeInsets.only(top: 25.0),
              //     child: TextFormField(
              //       // controller: _emailController,
              //       cursorColor: Colors.blueAccent,
              //       keyboardType: TextInputType.emailAddress,
              //       maxLength: 50,
              //       obscureText: false,
              //       // onChanged: (value) => model.email = value,
              //       validator: (value) {
              //               return Validators().evalEmail(value!);
              //       },
              //       // onSaved: (value) => _email = value,
              //       decoration: InputDecoration(
              //         icon: const Icon(Icons.email),
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(16.0)),
              //         hintText: 'emailID',
              //         labelText: 'EmailID *',
              //         // errorText: snapshot.error,
              //       ),
              //     )),
              // Container(
              //   margin: const EdgeInsets.only(top: 5.0),
              // ),
              // Container(
              //     width: 300.0,
              //     margin: const EdgeInsets.only(top: 25.0),
              //     child: TextFormField(
              //       // controller: _emailController,
              //       cursorColor: Colors.blueAccent,
              //       keyboardType: TextInputType.emailAddress,
              //       maxLength: 50,
              //       obscureText: false,
              //       // onChanged: (value) => model.email = value,
              //       validator: (value) {
              //               return Validators().evalEmail(value!);
              //       },
              //       // onSaved: (value) => _email = value,
              //       decoration: InputDecoration(
              //         icon: const Icon(Icons.phone),
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(16.0)),
              //         hintText: 'Phone #',
              //         labelText: 'Phone *',
              //         // errorText: snapshot.error,
              //       ),
              //     )),
              //     Container(
              //   margin: const EdgeInsets.only(top: 5.0),
              // ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    controller: _dttmController,
                    cursorColor: Colors.blueAccent,
                    // keyboardType: TextInputType.emailAddress,
                    maxLength: 100,
                    obscureText: false,
                    onChanged: (value) => model.dttm = value,
                    validator: (value) {
                            return Validators().evalName(value!);
                    },
                    // onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.punch_clock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      hintText: 'Pickup Datatime',
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
                    maxLength: 100,
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
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              const Text("upload documents", style: cBodyText,),
              // Container(
              //     width: 300.0,
              //     margin: const EdgeInsets.only(top: 25.0),
              //     child: TextFormField(
              //       controller: _passwordController,
              //       cursorColor: Colors.blueAccent,
              //       keyboardType: TextInputType.visiblePassword,
              //       maxLength: 50,
              //       obscureText: true,
              //       onChanged: (value) => model.password = value,
              //       validator: (value) {
              //               return Validators().evalPassword(value!);
              //       },
              //       decoration: InputDecoration(
              //         icon: const Icon(Icons.lock_outline),
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(16.0)),
              //         hintText: 'enter password',
              //         labelText: 'Password *',
              //       ),
              //     )),
              CustomSpinner(toggleSpinner: spinnerVisible, key: null),
              CustomMessage(
                  toggleMessage: messageVisible,
                  toggleMessageType: messageType,
                  toggleMessageTxt: messageTxt, key: null,),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              // signinSubmitBtn(context, authBloc),
              sendBtn(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget sendBtn(context) {
    return ElevatedButton(
      onPressed:
          _btnEnabled == true ? () => setRide(model) : null,
      child: const Text('book')
    );
  }

  Widget loginPage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.warning, color: Colors.red,),
              ),
              label: Text("please Login again, you are currently signed out.", style: cErrorText)),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('Login'),
            // color: Colors.blue,
            onPressed: () { Navigator.pushNamed(
                    context,
                    '/',
                  );},
          ),
        ],
      ),
    );
  }
}