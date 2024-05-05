import 'package:flutter/material.dart';
import './views/app.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'WrvzAjowhrUSgve8M5ldnC9vGDGgsX20yV1J3OxQ';
  const keyClientKey = 'U0qoxUwShwrjf5A09scbjX2Aeot4mCvkobbsvYan';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
      // var firstObject = ParseObject('FirstClass')..set(
      //                 'message', 'Hey ! Second message from Flutter. Parse is now connected');
      // await firstObject.save();  
      // print('done');

  runApp(const App());
}