//
//  ViewModifiers.swift
//  BLEMonitor
//
//  Created by JWLK on 2021/03/24.
//

import Foundation
import SwiftUI

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}


struct ScrollMain: View {
    var body: some View {
        VStack(spacing: 5){
            Text("test")
            Text("test")
            Text("test").font(.system(size: 53, weight: .medium))
        }
        .frame(maxWidth:.infinity, minHeight: 70, alignment: .center)
        .background(Color.white)
        
        
    }
}
