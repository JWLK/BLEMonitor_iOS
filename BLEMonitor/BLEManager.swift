//
//  BLEManager.swift
//  BLEMonitor
//
//  Created by JWLK on 2021/04/03.
//

import Foundation
import CoreBluetooth

struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
    let data: CBPeripheral
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @Published var tempDataString = "00.00"
    var tempCentralManager: CBCentralManager!
    
//    var tempRatePeripheral: CBPeripheral!
    
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    
    /*
        let serviceUUID = CBUUID(string: "00001809-0000-1000-8000-00805f9b34fb")
    */
    
    let targetServiceUUID = CBUUID(string: "00001809-0000-1000-8000-00805f9b34fb")
    let targetCharacteristicUUID = CBUUID(string: "00002a1c-0000-1000-8000-00805f9b34fb")

    override init() {
        super.init()
        tempCentralManager = CBCentralManager(delegate: self, queue: nil)
        tempCentralManager.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
            
            /* If yout want Auto Scaning Initilization*/
            //bleCentralManger.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            isSwitchedOn = false
        }
    }
    
    // centralManager: DidDiscover
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
        
        let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue, data: peripheral)
        
        peripherals.append(newPeripheral)
        
        print(newPeripheral)
        print(advertisementData)
    }
    
    // centralManager: Connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        peripheral.discoverServices([targetServiceUUID])
        
    }
    
    // CBPeripheralManagerDelegate : didDiscover Service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            print(service)
            print(service.characteristics ?? "characteristics are nil")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    // CBPeripheralManagerDelegate : didDiscover Service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            print(characteristic)
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.indicate) {
                print("\(characteristic.uuid): properties contains .indicate")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    // CBPeripheralManagerDelegate : didUpdateValueFor Service
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
            case targetCharacteristicUUID:
                let tempValue = tempRate(from: characteristic)
                print(tempValue)
                tempDataString = String(tempValue)
            default:
                print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
        
        guard characteristic.value != nil else {
            return
        }
        
    }
    
    private func tempRate(from characteristic: CBCharacteristic) -> Float {
        guard let characteristicData = characteristic.value else { return -1 }
        let byteArray = [UInt8](characteristicData)
        
        /* Temp Flag*//*
        let tempDataFlagUnit = byteArray[0] & 0x01
        if tempDataFlagUnit == 0 {
            print("Temperature Units Flag Type : Celsius")
        } else {
            print("Temperature Units Flag Type : Fahrenheit")
        }
        */
        
        /*
         Temp Data Conversion
         */
        let tempByteRow = Int(byteArray[1])
        let tempByteHigh = Int(byteArray[2]) << 8
        let tempDataOrigin = tempByteHigh + tempByteRow
        let tempDataConvertDigit = Int8(bitPattern: byteArray[4])
        //print(tempDataConvertDigit)
        let tempDataRestore:Float = Float(tempDataOrigin) * pow(10, Float(tempDataConvertDigit))

        return tempDataRestore
    }

    //Auto Scan Background : Disconnected
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.peripherals = []
        tempCentralManager.scanForPeripherals(withServices: [targetServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    
    //Button Event Control
    func startScanning() {
        print("startScanning")
        tempCentralManager.scanForPeripherals(withServices: [targetServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    func stopScanning() {
        print("stopScanning")
        tempCentralManager.stopScan()
    }
    
    func connectDevice(peripheral: CBPeripheral) {
        print("connectDevice")
        tempCentralManager.stopScan()
        peripheral.delegate = self
        tempCentralManager.connect(peripheral)
    }
    
    
}
