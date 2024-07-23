import 'package:flutter/material.dart';
import '../shared/constants.dart';
import '../models/datamodel.dart';
import '../models/validators.dart';
import '../blocs/auth.bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  static const routeName = '/settings';
  Settings(
      {super.key,
      required this.handleBrightnessChange,
      required this.setLocale});

  Function(bool useLightMode) handleBrightnessChange;
  Function(Locale _locale) setLocale;
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  bool isUserValid = true;
  bool fileUpload = false;
  // bool light = true;
  // bool customer = true;
  // bool provider = false;
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
    await authBloc.getUserSettingsDoc().then((res) => {
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
    userData = await authBloc.setUserSettingsDoc(model);
    if (userData == true) {
      showMessage(true, "success", "user settings updated.");
      loadAuthState();
    } else {
      showMessage(
          true, "error", "something went wrong, please contact your Admin.");
    }
    toggleSpinner();
  }

  void navigateToUser() {
    Navigator.pushReplacementNamed(context, '/');
  }

  void logout() async {
    // setState(() {
    //   model.password = "";
    //   _passwordController.clear();
    //   _btnEnabled = false;
    // });
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
              // SizedBox(
              //   width: 300,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(light ? "Customer": "Driver"),
              //       Switch(
              //       // This bool value toggles the switch.
              //           value: light,
              //           activeColor: Colors.green,
              //           inactiveTrackColor: Colors.amberAccent,
              //           // overlayColor: overlayColor,
              //           // trackColor: trackColor,
              //           thumbColor: const MaterialStatePropertyAll<Color>(Color.fromARGB(255, 0, 0, 0)),
              //           onChanged: (bool value) {
              //           // This is called when the user toggles the switch.
              //           setState(() {
              //               light = value;
              //           });},),
              //     ]
              //   ),
              // ),
              // SizedBox(
              //   width: 300,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       IconButton(
              //         icon: const Icon(Icons.business),
              //         tooltip: 'Provider',
              //         onPressed: () {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(content: Text('Request a provider business account. **Additional documentation is required.')));
              //         },
              //         ),
              //       const Text("Provider"),
              //       Switch(
              //       // This bool value toggles the switch.
              //           value: provider,
              //           activeColor: Colors.green,
              //           inactiveTrackColor: Colors.grey,
              //           // overlayColor: overlayColor,
              //           // trackColor: trackColor,
              //           thumbColor: const MaterialStatePropertyAll<Color>(Color.fromARGB(255, 0, 0, 0)),
              //           onChanged: (bool value) {
              //           // This is called when the user toggles the switch.
              //           setState(() {
              //               provider = value;
              //               light = !light;
              //           });},),
              //     ]
              //   ),
              // ),
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
              (fileUpload == true) ? Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SavePage(docType: "docs", docId: model.uid)),
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
                      MaterialPageRoute(builder: (context) => DisplayPage(docType: "docs", docId: model.uid)),
                    );
                  },
                  child: const Text("display documents")),
                ],
              ) : const Text("save settings before document upload"),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              // signinSubmitBtn(context, authBloc),
              sendBtn(context),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              ElevatedButton(
                child: const Text('reset password'),
                // color: Colors.blue,
                onPressed: () {
                  showAlertDialog(context);
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 15.0),
              ),
              ElevatedButton(
                child: const Text('Log out'),
                // color: Colors.blue,
                onPressed: () {
                  logout();
                },
              ),
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

class SavePage extends StatefulWidget {
  final String docType;
  final String docId;
  const SavePage({super.key, required this.docType, required this.docId});
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
                          final gallery = await authBloc.setUserFileDoc(
                              widget.docType, widget.docId, parseFile);
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
  final String docType;
  final String docId;
  const DisplayPage({super.key, required this.docType, required this.docId});
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
          future: authBloc.getGalleryList(widget.docType, widget.docId),
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