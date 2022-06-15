// import 'package:norgic_vdotok/src/signaling/socketManager/socketManagerForIO.dart';
// import 'package:norgic_vdotok/src/signaling/socketManager/socketManagerForWeb.dart';
import 'dart:typed_data';

import '../jsManager/jsManagerStub.dart'
    if (dart.library.io) '../jsManager/jsManagerForIO.dart'
    if (dart.library.html) '../jsManager/jsManagerForWeb.dart';

abstract class JsManager {
  static JsManager? _instance;

  static JsManager? get instance {
    _instance ??= getJsManager();
    return _instance;
  }

  Future<dynamic> connect(Uint8List bytes, String ext);
}
