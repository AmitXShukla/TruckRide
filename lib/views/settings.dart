import 'package:flutter/material.dart';
import '../shared/constants.dart';
import '../models/datamodel.dart';
import '../models/validators.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  static const routeName = '/settings';
  Settings({super.key,
  required this.handleBrightnessChange});

  Function(bool useLightMode) handleBrightnessChange;
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  bool light = true;
  bool provider = false;
  bool spinnerVisible = false;
  bool messageVisible = false;
  bool _btnEnabled = false;
  String messageTxt = "";
  String messageType = "";
  final _formKey = GlobalKey<FormState>();
  var model = PromptDataModel(prompt: 'none', res: 'na');
  final TextEditingController _txtController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _txtController.dispose();
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

  fetchData(String prompt) async {
    toggleSpinner();
    // ignore: prefer_typing_uninitialized_variables
    // var userAuth;
    if (prompt != "") {
      // userAuth = await authBloc.signInWithGoogle();
      showMessage(
          true,
          "success",
          prompt);
    } else {
      showMessage(
          true,
          "error",
          "no text found in Prompt.");
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
              // child: authBloc.isSignedIn()
              //     ? settingsPage(authBloc)
              //     : userForm(authBloc)));
              child: userForm(context))),
    );
  }

  Widget userForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      onChanged: () =>
          setState(() => _btnEnabled = _formKey.currentState!.validate()),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              // const Image(image: AssetImage('../assets/afronalalogo.png'), width: 200, height: 200,),
              const Text("update settings", style: cBodyText,),
              // Container(
              //   margin: const EdgeInsets.only(top: 25.0),
              // ),
              // const Text(
              //     "create a new Account .\n\nPlease use your email and non-secret password.",
              //     style: cBodyText),
              // const SizedBox(
              //   width: 10,
              //   height: 10,
              // ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(light ? "Customer": "Driver"),
                    Switch(
                    // This bool value toggles the switch.
                        value: light,
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.amberAccent,
                        // overlayColor: overlayColor,
                        // trackColor: trackColor,
                        thumbColor: const MaterialStatePropertyAll<Color>(Color.fromARGB(255, 0, 0, 0)),
                        onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                            light = value;
                        });},),
                  ]
                ),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.business),
                      tooltip: 'Provider',
                      onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request a provider business account. **Additional documentation is required.')));
                      },
                      ),
                    const Text("Provider"),
                    Switch(
                    // This bool value toggles the switch.
                        value: provider,
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.grey,
                        // overlayColor: overlayColor,
                        // trackColor: trackColor,
                        thumbColor: const MaterialStatePropertyAll<Color>(Color.fromARGB(255, 0, 0, 0)),
                        onChanged: (bool value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                            provider = value;
                            light = !light;
                        });},),
                  ]
                ),
              ),
              Container(
                  width: 300.0,
                  margin: const EdgeInsets.only(top: 25.0),
                  child: TextFormField(
                    // controller: _emailController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    // onChanged: (value) => model.email = value,
                    validator: (value) {
                            return Validators().evalEmail(value!);
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
                    // controller: _emailController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    // onChanged: (value) => model.email = value,
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
                    // controller: _emailController,
                    cursorColor: Colors.blueAccent,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 50,
                    obscureText: false,
                    // onChanged: (value) => model.email = value,
                    validator: (value) {
                            return Validators().evalEmail(value!);
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
              const Text("reset password", style: cBodyText,),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
              ),
              const Text("upload profile photo", style: cBodyText,),
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
          _btnEnabled == true ? () => fetchData(model.prompt) : null,
      child: const Text('save')
    );
  }

  Widget settingsPage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.warning, color: Colors.red,),
              ),
              label: Text("please sign in after some time. Your free trial expired. \n\n Please upgrade to Pro to get unlimited access.", style: cWarnText)),
          const SizedBox(width: 20, height: 50),
          ElevatedButton(
            child: const Text('Home'),
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
