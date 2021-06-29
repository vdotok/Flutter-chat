import 'dart:typed_data';
import '../jsManager/jsManager.dart';
import 'dart:js' as js;
//other imports

class JSManagerForWeb extends JsManager {
  @override
  Future<dynamic> connect(Uint8List bytes, String ext) async {
    final url = js.context.callMethod('unit8ListToUrl', [bytes, ext]);
    return url;
    //stuff that uses dart:js
    // MqttServerClient mqtt = MqttServerClient(url, "");
    // return mqtt;
  }
}

JsManager getJsManager() => JSManagerForWeb();
