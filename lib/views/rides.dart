import 'package:flutter/material.dart';
import '../shared/constants.dart';
import '../models/datamodel.dart';

// ignore: must_be_immutable
class Rides extends StatefulWidget {
  static const routeName = '/rides';
  Rides({super.key,
  required this.handleBrightnessChange});

  Function(bool useLightMode) handleBrightnessChange;
  @override
  RidesState createState() => RidesState();
}

class RidesState extends State<Rides> {
  bool light = true;
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

    getData(filter, docId) {

    // return qry.limit(10).snapshots();
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
      child: showPersonHistory(context),
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

Widget showPersonHistory(BuildContext context) {
  return CustomScrollView(
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
                  backgroundColor: Colors.green,
                  // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      )),
                  label: Text("Request a new ride")
                ),
            ),
          //   IconButton(
          //   icon: const Icon(Icons.add, color: Colors.greenAccent,),
          //   tooltip: 'Request new ride',
          //   onPressed: () {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(content: Text('MAKING EVERY DELIVERY A DELIGHT')));
          //   },
          // ),
            const Text("Rides", style: cSuccessText,),
            // const Text("Date: April 13, 2024 04:51am"),
            // const Text('Ride ID: '),
            // const Text('From: Los Angeles'),
            // const Text('To: Sacramento'),
            // const Text('Provider ID: '),
            // const Text('Details: in progress.'),
            // const SizedBox(height: 15,),
            // const Text("Past Rides", style: cNavText,),
            // const Text("Date: April 11, 2024 04:51am"),
            // const Text('Ride ID: '),
            // const Text('From: Los Angeles'),
            // const Text('To: Sacramento'),
            // const Text('Provider ID: '),
            // const Text('Details: 600kms, half load, 9 hours journery.'),
            // const SizedBox(height: 15,),
            // const Text("Date: April 11, 2024 04:51am"),
            // const Text('Ride ID: '),
            // const Text('From: Los Angeles'),
            // const Text('To: Sacramento'),
            // const Text('Provider ID: '),
            // const Text('Details: 600kms, half load, 9 hours journery.'),
            // const SizedBox(height: 15,),
            // const Text("Date: April 11, 2024 04:51am"),
            // const Text('Ride ID: '),
            // const Text('From: Los Angeles'),
            // const Text('To: Sacramento'),
            // const Text('Provider ID: '),
            // const Text('Details: 600kms, half load, 9 hours journery.'),
            // const SizedBox(height: 15,)
            DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Date',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'From-To',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Provider',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Status',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 14 10:00 AM')),
            DataCell(Text('600kms, half load, 9 hours journery.')),
            DataCell(Text('Afro Nala')),
            DataCell(Row(
              children: [
                Icon(Icons.hourglass_bottom, color: Colors.orangeAccent,),
                SizedBox(width: 5,),
                Icon(Icons.edit, color: Colors.greenAccent,),
              ],
            ),),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 12 11:00 AM')),
            DataCell(Text('1600kms, full load, 9 hours journery.')),
            DataCell(Text('Albert C.')),
            DataCell(Icon(Icons.zoom_in, color: Colors.grey,),),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 11 11:00 AM')),
            DataCell(Text('1600kms, full load, 9 hours journery.')),
            DataCell(Text('Greg C.')),
            DataCell(Icon(Icons.zoom_in, color: Colors.grey,),),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 08 11:00 AM')),
            DataCell(Text('100kms, full load, 3 hours journery.')),
            DataCell(Text('Albert C.')),
            DataCell(Icon(Icons.zoom_in, color: Colors.grey,),),
          ],
        ),
      ],
    )
          ],
        ),
      ),
    ),
  ],
);
}
}