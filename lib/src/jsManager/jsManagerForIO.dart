import 'dart:typed_data';
import '../jsManager/jsManager.dart';

//other imports

class JSManagerForIO extends JsManager {
  @override
  Future<dynamic> connect(Uint8List bytes, String ext) async {
    //stuff that uses dart:js
    // MqttServerClient mqtt = MqttServerClient(url, "");
    // return mqtt;
  }
}

JsManager getJsManager() => JSManagerForIO();
