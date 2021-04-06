//
//  ContentView.swift
//  BLEMonitor
//
//  Created by JWLK on 2021/04/03.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var bleManager = BLEManager()
    
    var body: some View {
        VStack (spacing: 10) {

            Text("Bluetooth Devices")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            List(bleManager.peripherals) { peripheral in
                HStack {
                    Text(peripheral.name)
                    Spacer()
                    
                    Button(action: {
                        self.bleManager.connectDevice(peripheral: peripheral.data)
                    }) {
                        Text("Connect")
                    }
                }
            }.frame(height: 300)
            
            Spacer()
            
            Text("Temperature Type")
                .font(.headline)
            
            
            HStack{
                Spacer()
                Text(bleManager.tempDataString)
                    .fontWeight(.regular)
                    .padding(.leading, 30)
                    .foregroundColor(.purple)
                Text("°C")
                    .fontWeight(.regular)
                    .foregroundColor(.purple)
                Spacer()
            }


            Text("STATUS")
                .font(.headline)

            // Status goes here
            if bleManager.isSwitchedOn {
                Text("Bluetooth is switched on")
                    .foregroundColor(.green)
            }
            else {
                Text("Bluetooth is NOT switched on")
                    .foregroundColor(.red)
            }

            Spacer()

            HStack {
                VStack (spacing: 10) {
                    Button(action: {
                        print("Start Scanning")
                        self.bleManager.startScanning()
                    }) {
                        Text("Start Scanning")
                    }
                    Button(action: {
                        print("Stop Scanning")
                        self.bleManager.stopScanning()
                    }) {
                        Text("Stop Scanning")
                    }
                }.padding()

                Spacer()

                VStack (spacing: 10) {
                    Button(action: {
                        print("Start Advertising")
                    }) {
                        Text("Start Advertising")
                    }
                    Button(action: {
                        print("Stop Advertising")
                    }) {
                        Text("Stop Advertising")
                    }
                }.padding()
                
            }
            
            Button(action: {
                self.bleManager.peripherals = []
            }) {
                Text("Clear Data")
                    .foregroundColor(.red)
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
