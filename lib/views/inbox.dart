import 'package:flutter/material.dart';
import '../shared/constants.dart';
import '../models/datamodel.dart';

// ignore: must_be_immutable
class Inbox extends StatefulWidget {
  static const routeName = '/inbox';
  Inbox({super.key,
  required this.handleBrightnessChange});

  Function(bool useLightMode) handleBrightnessChange;

  @override
  InboxState createState() => InboxState();
}

class InboxState extends State<Inbox> {
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
                    '/message',
                  );
                },
              child: const Chip(
                  backgroundColor: Colors.blueAccent,
                  // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      )),
                  label: Text("send a message")
                ),
            ),
            const Text("Messages", style: cSuccessText,),
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
              'Message',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Action',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 14 10:00 AM')),
            DataCell(Text('Congratulations on booking a new Ride. A provider will connect with you soon.')),
            DataCell(Row(
              children: [
                Icon(Icons.delete, color: Colors.red,),
                SizedBox(width: 2,),
                Icon(Icons.check, color: Colors.green,),
              ],
            ),),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 12 10:00 AM')),
            DataCell(Text('Congratulations on booking a new Ride. A provider will connect with you soon.')),
            DataCell(Row(
              children: [
                Icon(Icons.delete, color: Colors.red,),
                SizedBox(width: 2,),
                Icon(Icons.check, color: Colors.green,),
              ],
            ),),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 08 10:50 AM')),
            DataCell(Text('You have a new Ride alert. A provider has a new status update on your ride.')),
            DataCell(Row(
              children: [
                Icon(Icons.delete, color: Colors.red,),
                SizedBox(width: 2,),
                Icon(Icons.check, color: Colors.green,),
              ],
            ),),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 07 11:00 AM')),
            DataCell(Text('You have a new Ride alert. A provider has a new status update on your ride.')),
            DataCell(Row(
              children: [
                Icon(Icons.delete, color: Colors.red,),
                SizedBox(width: 2,),
                Icon(Icons.check, color: Colors.green,),
              ],
            ),),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 06 11:00 AM')),
            DataCell(Text('You have a new Ride alert. A provider has a new status update on your ride.')),
            DataCell(Row(
              children: [
                Icon(Icons.delete, color: Colors.red,),
                SizedBox(width: 2,),
                Icon(Icons.check, color: Colors.grey,),
              ],
            ),),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Apr 05 11:00 AM')),
            DataCell(Text('You have a new Ride alert. A provider has a new status update on your ride.')),
            DataCell(Row(
              children: [
                Icon(Icons.delete, color: Colors.red,),
                SizedBox(width: 2,),
                Icon(Icons.check, color: Colors.grey,),
              ],
            ),),
          ],
        ),
      ],
    )
            // const Text("Messages", style: cSuccessText,),
            // const Text("Date: April 11, 2024 04:51am"),
            // const Text('Congratulations on booking a new Ride. A provider will connect with you soon.'),
            // const Icon(Icons.delete_forever, color: Colors.redAccent,),
            // const Text("Date: April 10, 2024 10:51am"),
            // const Text('You have a new Ride alert. A provider has a new status update on your ride.'),
            // const Icon(Icons.delete_forever, color: Colors.redAccent,),
            // const SizedBox(height: 15,),
            // const Text("Date: April 08, 2024 08:51am"),
            // const Text('You have a new Ride alert. A provider has a new status update on your ride.'),
            // const Icon(Icons.delete_forever, color: Colors.redAccent,),
            // const SizedBox(height: 15,),
            // const Text("Date: April 05, 2024 10:51am"),
            // const Text('You have a new Ride alert. A provider has a new status update on your ride.'),
            // const Icon(Icons.delete_forever, color: Colors.redAccent,),
            // const SizedBox(height: 15,)
          ],
        ),
      ),
    ),
  ],
);
}
}