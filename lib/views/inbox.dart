// import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../shared/constants.dart';
import '../models/datamodel.dart';
import '../blocs/auth.bloc.dart';

// ignore: must_be_immutable
class Inbox extends StatefulWidget {
  static const routeName = '/inbox';
  Inbox({super.key, required this.handleBrightnessChange});

  Function(bool useLightMode) handleBrightnessChange;

  @override
  InboxState createState() => InboxState();
}

class InboxState extends State<Inbox> {
  List<DataRow> dataRows = [];
  List<ParseObject> results = <ParseObject>[];
  // ignore: prefer_typing_uninitialized_variables
  bool isUserValid = true;
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";
  List data = [
    InboxModel(
        dttm: 'none',
        from: 'na',
        to: 'na',
        message: 'na',
        readReceipt: false,
        fileURL: 'na')
  ];

  @override
  void initState() {
    loadAuthState();
    super.initState();
  }

  void loadAuthState() async {
    final userState = await authBloc.isSignedIn();
    setState(() => isUserValid = userState);
    getData();
  }

  @override
  void dispose() {
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

  getData() async {
    toggleSpinner();
    var data = await authBloc.getData("Messages", "-");
    setState(() => results = data);
    toggleSpinner();
  }

  deleteData(docID) async {
    await authBloc.delDoc("Messages", docID);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: createCustomerNavBar(context, widget),
        body: Material(
            child: Container(
                margin: const EdgeInsets.all(20.0),
                child: (isUserValid == true)
                    ? messageHistory(context)
                    : loginPage(context))));
  }

  Widget messageHistory(BuildContext context) {
    if (results.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            itemCount: results.isEmpty ? 1 : results.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // return the header
                return Row(
                  children: [
                    const Text(
                      "Messages",
                      style: cNavText,
                    ),
                    const SizedBox(
                      width: 40,
                    ),
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
                          label: Text("send a message")),
                    ),
                  ],
                );
              }
              index -= 1;
              final item = results[index];
              return ListTile(
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text(item["dttm"].toString().substring(0, 10)),
                        const SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          onPressed: () {
                            showAlertDialog(
                                context, item["objectId"].toString());
                          },
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                        )
                      ],
                    ),
                  ],
                ),
                subtitle: Text(item["message"].toString()),
              );
            }),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            itemCount: 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // return the header
                return Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Messages",
                          style: cNavText,
                        ),
                        const SizedBox(
                          width: 40,
                        ),
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
                              label: Text("send a message")),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                      height: 40,
                    ),
                    CustomSpinner(toggleSpinner: spinnerVisible, key: null),
                    const Row(
                      children: [
                        Text(
                          "You have no messages",
                          style: cNavText,
                        )
                      ],
                    ),
                  ],
                );
              }
              return null;
            }),
      );
    }
  }
  // Widget messageHistory(BuildContext context) {
  //   return CustomScrollView(
  //     slivers: <Widget>[
  //       SliverPadding(
  //         padding: const EdgeInsets.all(20.0),
  //         sliver: SliverList(
  //           delegate: SliverChildListDelegate(
  //             <Widget>[
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.pushNamed(
  //                     context,
  //                     '/message',
  //                   );
  //                 },
  //                 child: const Chip(
  //                     backgroundColor: Colors.blueAccent,
  //                     // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.only(
  //                       topRight: Radius.circular(15),
  //                       bottomRight: Radius.circular(15),
  //                       topLeft: Radius.circular(15),
  //                       bottomLeft: Radius.circular(15),
  //                     )),
  //                     label: Text("send a message")),
  //               ),
  //               const Text(
  //                 "Messages",
  //                 style: cSuccessText,
  //               ),
  //               DataTable(
  //                 columns: const <DataColumn>[
  //                   DataColumn(
  //                     label: Expanded(
  //                       child: Text(
  //                         'Date',
  //                         style: TextStyle(fontStyle: FontStyle.italic),
  //                       ),
  //                     ),
  //                   ),
  //                   DataColumn(
  //                     label: Expanded(
  //                       child: Text(
  //                         'Message',
  //                         style: TextStyle(fontStyle: FontStyle.italic),
  //                       ),
  //                     ),
  //                   ),
  //                   DataColumn(
  //                     label: Expanded(
  //                       child: Text(
  //                         'Action',
  //                         style: TextStyle(fontStyle: FontStyle.italic),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //                 rows: dataRows,
  //                 // rows: const [DataRow(
  //                 //   cells: <DataCell>[
  //                 //     DataCell(Text("data")),
  //                 //     DataCell(Text("data")),
  //                 //     DataCell(Text("data"))
  //                 //   ]
  //                 // )],
  //                 // rows: const <DataRow>[
  //                 //   DataRow(
  //                 //     cells: <DataCell>[
  //                 //       DataCell(Text('Apr 14 10:00 AM')),
  //                 //       DataCell(Text(
  //                 //           'Congratulations on booking a new Ride. A provider will connect with you soon.')),
  //                 //       DataCell(
  //                 //         Row(
  //                 //           children: [
  //                 //             Icon(
  //                 //               Icons.delete,
  //                 //               color: Colors.red,
  //                 //             ),
  //                 //             SizedBox(
  //                 //               width: 2,
  //                 //             ),
  //                 //             Icon(
  //                 //               Icons.check,
  //                 //               color: Colors.green,
  //                 //             ),
  //                 //           ],
  //                 //         ),
  //                 //       ),
  //                 //     ],
  //                 //   ),
  //                 //   DataRow(
  //                 //     cells: <DataCell>[
  //                 //       DataCell(Text('Apr 12 10:00 AM')),
  //                 //       DataCell(Text(
  //                 //           'Congratulations on booking a new Ride. A provider will connect with you soon.')),
  //                 //       DataCell(
  //                 //         Row(
  //                 //           children: [
  //                 //             Icon(
  //                 //               Icons.delete,
  //                 //               color: Colors.red,
  //                 //             ),
  //                 //             SizedBox(
  //                 //               width: 2,
  //                 //             ),
  //                 //             Icon(
  //                 //               Icons.check,
  //                 //               color: Colors.green,
  //                 //             ),
  //                 //           ],
  //                 //         ),
  //                 //       ),
  //                 //     ],
  //                 //   ),
  //                 // ],
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

// Widget messageHistory(BuildContext context) {
//   return CustomScrollView(
//   slivers: <Widget>[
//     SliverPadding(
//       padding: const EdgeInsets.all(20.0),
//       sliver: SliverList(
//         delegate: SliverChildListDelegate(
//           <Widget>[
//             GestureDetector(
//               onTap: () {
//                   Navigator.pushNamed(
//                     context,
//                     '/message',
//                   );
//                 },
//               child: const Chip(
//                   backgroundColor: Colors.blueAccent,
//                   // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(15),
//                       bottomRight: Radius.circular(15),
//                       topLeft: Radius.circular(15),
//                       bottomLeft: Radius.circular(15),
//                       )),
//                   label: Text("send a message")
//                 ),
//             ),
//             const Text("Messages", style: cSuccessText,),
//             DataTable(
//       columns: const <DataColumn>[
//         DataColumn(
//           label: Expanded(
//             child: Text(
//               'Date',
//               style: TextStyle(fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//         DataColumn(
//           label: Expanded(
//             child: Text(
//               'Message',
//               style: TextStyle(fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//         DataColumn(
//           label: Expanded(
//             child: Text(
//               'Action',
//               style: TextStyle(fontStyle: FontStyle.italic),
//             ),
//           ),
//         ),
//       ],
//       rows: const <DataRow>[
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Apr 14 10:00 AM')),
//             DataCell(Text('Congratulations on booking a new Ride. A provider will connect with you soon.')),
//             DataCell(Row(
//               children: [
//                 Icon(Icons.delete, color: Colors.red,),
//                 SizedBox(width: 2,),
//                 Icon(Icons.check, color: Colors.green,),
//               ],
//             ),),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Apr 12 10:00 AM')),
//             DataCell(Text('Congratulations on booking a new Ride. A provider will connect with you soon.')),
//             DataCell(Row(
//               children: [
//                 Icon(Icons.delete, color: Colors.red,),
//                 SizedBox(width: 2,),
//                 Icon(Icons.check, color: Colors.green,),
//               ],
//             ),),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Apr 08 10:50 AM')),
//             DataCell(Text('You have a new Ride alert. A provider has a new status update on your ride.')),
//             DataCell(Row(
//               children: [
//                 Icon(Icons.delete, color: Colors.red,),
//                 SizedBox(width: 2,),
//                 Icon(Icons.check, color: Colors.green,),
//               ],
//             ),),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Apr 07 11:00 AM')),
//             DataCell(Text('You have a new Ride alert. A provider has a new status update on your ride.')),
//             DataCell(Row(
//               children: [
//                 Icon(Icons.delete, color: Colors.red,),
//                 SizedBox(width: 2,),
//                 Icon(Icons.check, color: Colors.green,),
//               ],
//             ),),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Apr 06 11:00 AM')),
//             DataCell(Text('You have a new Ride alert. A provider has a new status update on your ride.')),
//             DataCell(Row(
//               children: [
//                 Icon(Icons.delete, color: Colors.red,),
//                 SizedBox(width: 2,),
//                 Icon(Icons.check, color: Colors.grey,),
//               ],
//             ),),
//           ],
//         ),
//         DataRow(
//           cells: <DataCell>[
//             DataCell(Text('Apr 05 11:00 AM')),
//             DataCell(Text('You have a new Ride alert. A provider has a new status update on your ride.')),
//             DataCell(Row(
//               children: [
//                 Icon(Icons.delete, color: Colors.red,),
//                 SizedBox(width: 2,),
//                 Icon(Icons.check, color: Colors.grey,),
//               ],
//             ),),
//           ],
//         ),
//       ],
//     )
//             // const Text("Messages", style: cSuccessText,),
//             // const Text("Date: April 11, 2024 04:51am"),
//             // const Text('Congratulations on booking a new Ride. A provider will connect with you soon.'),
//             // const Icon(Icons.delete_forever, color: Colors.redAccent,),
//             // const Text("Date: April 10, 2024 10:51am"),
//             // const Text('You have a new Ride alert. A provider has a new status update on your ride.'),
//             // const Icon(Icons.delete_forever, color: Colors.redAccent,),
//             // const SizedBox(height: 15,),
//             // const Text("Date: April 08, 2024 08:51am"),
//             // const Text('You have a new Ride alert. A provider has a new status update on your ride.'),
//             // const Icon(Icons.delete_forever, color: Colors.redAccent,),
//             // const SizedBox(height: 15,),
//             // const Text("Date: April 05, 2024 10:51am"),
//             // const Text('You have a new Ride alert. A provider has a new status update on your ride.'),
//             // const Icon(Icons.delete_forever, color: Colors.redAccent,),
//             // const SizedBox(height: 15,)
//           ],
//         ),
//       ),
//     ),
//   ],
// );
// }

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

  showAlertDialog(BuildContext context, docId) {
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
        deleteData(docId);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Please confirm"),
      content: const Text("Would you like to delete this message ?"),
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
