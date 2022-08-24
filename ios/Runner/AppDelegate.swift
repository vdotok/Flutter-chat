//import UIKit
//import Flutter
//
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GeneratedPluginRegistrant.register(with: self)
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}


import UIKit
import Flutter
import WatchConnectivity

@available(iOS 9.3, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, WCSessionDelegate {
    
    var valueFromWatch: String = ""
    var appResult: FlutterResult? = nil;
    
    
    override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      
      if(WCSession.isSupported()){
                    let session = WCSession.default;
                    session.delegate = self;
                    session.activate();
      }
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      let channel = FlutterMethodChannel(name: "myWatchChannel",
                binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler({ [self]
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            appResult = result;
         if(call.method == "sendStringToNative"){
             
//             print((call.arguments as! [String : Any])["type"] as! String)
         // We will call a method called "sendStringToNative" in flutter.
            self.sendString(text: call.arguments  as! String)
             
            }
      })


        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
     
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("here is message from watch ", message);
//        valueFromWatch = (message["type"] as! String)
//        appResult!((message["counter"] as! String))
        
//        self.label.setText(message["counter"] as! String)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
     
    }
    
    func sendString(text: String){
        print(text)
        let session = WCSession.default;
        if(session.isPaired && session.isReachable){
         DispatchQueue.main.async {
                print("Sending counter...")
                session.sendMessage(["type": text], replyHandler: nil)
            }
        }else{
            print("Watch not reachable...")
        }
    }


}
