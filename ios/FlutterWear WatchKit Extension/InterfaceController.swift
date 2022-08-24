//
//  InterfaceController.swift
//  FlutterWear WatchKit Extension
//
//  Created by Taimoor khan on 16/08/2022.
//

import WatchKit
import Foundation
import FlutterVdotokWear



class InterfaceController: WKInterfaceController {
    
    let vdotokWear =  VdoTokWear()
    
    override func awake(withContext context: Any?) {
        print("awake")
        // Configure interface objects here.
       
    }
    
    override func willActivate() {
        print("willActivate")
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        print("didDeactivate")
        // This method is called when watch view controller is no longer visible
    }
    override func didAppear() {
        print("didAppear")
      
//        let vdotokWear = VdoTokWear()
//        vdotokWear.getHeartRate()
        
//        WatchLogs.printAction()
//        FlutterVdotokWe
        
       
    }
    

}
