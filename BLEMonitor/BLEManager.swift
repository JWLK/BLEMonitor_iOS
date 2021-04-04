//
//  BLEManager.swift
//  BLEMonitor
//
//  Created by JWLK on 2021/04/03.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    var myCentral: CBCentralManager!
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

    }
    
}
