import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../shared/constants.dart';
import '../models/datamodel.dart';
import '../blocs/auth.bloc.dart';

// ignore: must_be_immutable
class Rides extends StatefulWidget {
  static const routeName = '/rides';
  Rides({super.key, required this.handleBrightnessChange});

  Function(bool useLightMode) handleBrightnessChange;
  @override
  RidesState createState() => RidesState();
}

class RidesState extends State<Rides> {
  List<DataRow> dataRows = [];
  List<ParseObject> results = <ParseObject>[];
  // ignore: prefer_typing_uninitialized_variables
  bool isUserValid = true;
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  List data = [
    RideModel(
        objectId: '-',
        requestor: '-',
        dttm: '-',
        from: '-',
        to: '-',
        message: '-',
        loadType: '-',
        status: '-',
        fileURL: '-')
  ];

  @override
  void initState() {
    loadAuthState();
    super.initState();
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
    var data = await authBloc.getData("Rides", "-");
    setState(() => results = data);
    toggleSpinner();
  }

  deleteData(docID) async {
    await authBloc.delDoc("Rides", docID);
    getData();
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
                    ? rideHistory(context)
                    : loginPage(context))));
  }

  Widget rideHistory(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
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
                      label: Text("Request a new ride")),
                ),
                const Text(
                  "Rides",
                  style: cSuccessText,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
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
                            'Ride',
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
                                    res["dttm"].toString().substring(0, 11),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  Text(
                                    res["from"],
                                  ),
                                  const Text(":", style: cBodyText),
                                  Text(res["to"]),
                                ],
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    // iconSize: 20.0,
                                    onPressed: () {
                                      showAlertDialog(context, res);
                                    },
                                    icon: const Icon(Icons.zoom_in,
                                        color: Colors.blue),
                                    tooltip: 'Details',
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.fire_truck),
                                    color: Colors.brown,
                                    tooltip: 'Bids',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Click here to see Bids.')));
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
                                      showAlertDialog2(context);
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(const SnackBar(
                                      //         content: Text(
                                      //             'This Ride is in progress and can not be changed, for questions, please send us a mesage with Ride # and details.')));
                                    },
                                  )
                                  // IconButton(
                                  //     // iconSize: 20.0,
                                  //     icon: const Icon(Icons.edit,
                                  //         color: Colors.orange),
                                  //     onPressed: () {
                                  //       showAlertDialog(
                                  //           context, res["objectId"]);
                                  //     }),
                                  // IconButton(
                                  //     // iconSize: 20.0,
                                  //     icon: const Icon(Icons.delete,
                                  //         color: Colors.redAccent),
                                  //     onPressed: () {
                                  //       showAlertDialog(
                                  //           context, res["objectId"]);
                                  //     }),
                                ],
                              ),
                            )
                          ]),
                        )
                        .toList(),
                  ),
                )
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

  showAlertDialog(BuildContext context, res) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("ok"),
      onPressed: () {
        // deleteData(docId);
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
                Text(res['from'].toString()),
              ],
            ),
            Row(
              children: [
                const Text(
                  "To : ",
                  style: cNavText,
                ),
                Text(res['to'].toString()),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Message : ",
                  style: cNavText,
                ),
                Text(res['message'].toString()),
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
            Row(
              children: [
                const Text(
                  "Images : ",
                  style: cNavText,
                ),
                Text(res['fileURL'].toString()),
              ],
            ),
          ],
        ),
      ),
      actions: [
        // cancelButton,
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


showAlertDialog2(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("ok"),
      onPressed: () {
        // deleteData(docId);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Ride change request"),
      content: const SizedBox(
        width: 400,
        height: 300,
        child: Column(
          children: [
            Text(
              "This Ride is in progress.",
              style: cNavText,
              textAlign: TextAlign.left,
            ),
            Text(
              "This Ride can not be changed.",
              style: cNavText,
            ),
            SizedBox(height: 30,),
            Text(
              "for questions, please send us a mesage with Ride # and details.",
              style: cNavText,
            ),
          ],
        ),
      ),
      actions: [
        // cancelButton,
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