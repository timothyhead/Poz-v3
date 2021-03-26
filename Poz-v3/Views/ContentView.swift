//
//  ContentView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/23/21.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    
    @ObservedObject var settings = SettingsModel()
    @Environment(\.colorScheme) var colorScheme

    @State var tabIndex = 0
    
    var body: some View {
        VStack {
            
            if tabIndex == 0 {
                HomeView(settings: self.settings, tabIndex: $tabIndex)

            } else  if tabIndex == 1 {
                    addNoteView(tabIndex: $tabIndex)

                    
            }
            
        }
        .preferredColorScheme((settings.darkMode == true ? (.dark) : (.light)))
        .background(Color(UIColor(named: "HomeBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



