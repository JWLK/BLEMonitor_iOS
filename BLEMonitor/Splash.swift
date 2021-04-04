//
//  Splash.swift
//  BLEMonitor
//
//  Created by JWLK on 2021/04/03.
//

import SwiftUI

struct Splash: View {
    @State private var isActive = false
    let nextPage = ContentView()
    var body: some View {
        NavigationView {
            ZStack{
                Spacer().background(Color.whiteFFF)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    Spacer()
                    Image("SplashLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth:100,alignment: .center)
                        .padding(.top, 30)
                    
                    Text("BLEMonitor")
                        .foregroundColor(.mainActive)
                        .font(.system(size: 18, weight: .medium))
                        .padding(.top, 10)
                    Spacer()
                    Text("Copyright ⓒ 2020. JWLK All Rights Reserved.")
                        .foregroundColor(.gray707)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.top, 150)
                        .padding(.bottom, 30)
                    
                }.onAppear(perform: {
                    self.gotoLoginScreen(time: 2.5)
                })
                
                NavigationLink(destination: nextPage.hiddenNavigationBarStyle(),
                               isActive: $isActive,
                               label: { EmptyView() })
            }
        }
    }

    func gotoLoginScreen(time: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
            self.isActive = true
        }
    }
}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
