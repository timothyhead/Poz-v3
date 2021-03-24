//
//  ContentView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/23/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var settings = SettingsModel()
    
    @State var tabIndex = 0
    
    var body: some View {
        VStack {
        
            if tabIndex == 0 {
                HomeView(settings: self.settings)
                
            } else  if tabIndex == 1 {
                addNoteView()
                
            } else if tabIndex == 2 {
                DashboardView(settings: self.settings)
            }
            
            Spacer()
            TabsView(index: $tabIndex, settings: self.settings)
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
