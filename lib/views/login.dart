import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import '../shared/constants.dart';
import '../models/datamodel.dart';
import '../models/validators.dart';
import '../blocs/auth.bloc.dart';

// ignore: must_be_immutable
class LogIn extends StatefulWidget {
  static const routeName = '/login';
  LogIn({super.key,
  required this.handleBrightnessChange});

  Function(bool useLightMode) handleBrightnessChange;

  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LogIn> {

  bool isUserValid = false;
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool _btnEnabled = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  var model = LoginDataModel(email: 'noreply@duck.com', password: 'na',);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    loadAuthState();
    model.password = "";
    _passwordController.clear();
    _btnEnabled = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loadAuthState() async {
    final userState = await authBloc.isSignedIn();
    setState(() => isUserValid = userState);
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

  void login(String loginType) async {
    toggleSpinner();
    // ignore: prefer_typing_uninitialized_variables
    var userAuth;
    if (loginType == "Google") {
      userAuth = await authBloc.logInWithGoogle();
    } else {
      userAuth = await authBloc.logInWithEmail(model);
    }
  
    if (userAuth.success) {
      showMessage(true, "success", "Login successful. Please review your user settings.");
      await Future.delayed(const Duration(seconds: 2));
      navigateToUser();
    } else {
      showMessage(true, "error", userAuth.error!.message);
    }
    toggleSpinner();
  }

  void navigateToUser() {
    Navigator.pushReplacementNamed(context,'/');
  }

  void logout() async {
    setState(() {
      model.password = "";
      _passwordController.clear();
      _btnEnabled = false;
    });
    toggleSpinner();
    var val = await authBloc.logout();
    if (val == true) {
      showMessage(true, "success", "Successfully signed out.");
      setState(() => isUserValid = false);
      navigateToUser();
    } else {
      showMessage(true, "error", val.error!.message);
    }
    toggleSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: createAuthBar(context),
      appBar: createNavLogInBar(context, widget),
      body: Material(
          child: Container(
              child: (isUserValid == true)
                  ? settingsPage(context)
                  : userForm(context)))
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
              const Image(image: AssetImage('../assets/afronalalogo.png'), width: 200, height: 200,),
              SizedBox(
                  width: 300.0,
                  // margin: const EdgeInsets.only(top: 25.0),
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
                  toggleMessageTxt: messageTxt, key: null,),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              // signinSubmitBtn(context, authBloc),
              signinSubmitBtn(context),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              GestureDetector(
                onTap: () {
                  login("Google");
                },
                child: const Chip(
                  backgroundColor: Colors.red,
                  // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      )),
                  label: Text("Sign In with Google")
                ),
              ),
              // Chip(
              //     label: const Text("login with Google"),
              //     backgroundColor: Colors.red,
              //     avatar: ElevatedButton(
              //       child: const Text(''),
              //       // onPressed: () => fetchData(authBloc, "Google"),
              //       onPressed: () => {},
              //     )),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/signup',
                  );
                },
                child: const Chip(
                    avatar: CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: Text("+"),
                    ),
                    label: Text("create new Account")),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget signinSubmitBtn(context) {
    return ElevatedButton(
      onPressed:
          _btnEnabled == true ? () => login("email") : null,
      child: const Text('Sign In')
    );
  }

  Widget settingsPage(context) {
    return Center(
      child: Column(
        children: [
          // const Chip(
          //     avatar: CircleAvatar(
          //       backgroundColor: Colors.grey,
          //       child: Icon(Icons.home, color: Colors.blue,),
          //     ),
          //     label: Text("welcome to Manualify!.", style: cNavText)),
          const Text('Welcome Amit !'),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('click here to go to dashboard.'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/settings',
              );
            },
          ),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('click here to go to Providers dashboard.'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/settings',
              );
            },
          ),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('click here to go to Admin Portal.'),
            // color: Colors.blue,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/settings',
              );
            },
          ),
          const SizedBox(width: 20, height: 70),
          ElevatedButton(
            child: const Text('Logout'),
            // color: Colors.blue,
            onPressed: () {
              logout();
            },
          ),
        ],
      ),
    );
  }
}
