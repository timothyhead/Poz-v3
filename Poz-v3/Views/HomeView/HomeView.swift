//
//  HomeVIew.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/23/21.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var tabIndex: Int
    
    @State var bookOpenAnimation = false
    @State var prevPostsShowing = false
    
    var body: some View {
        
            
            VStack (alignment: .leading, spacing: 0) {
                
                if !bookOpenAnimation {
                    //top bar
                    HStack (alignment: .top, spacing: 10) {
                        //Hello Text
                        VStack (alignment: .leading, spacing: 0) {
                            Text("Good morning,")
                                .font(Font.custom("Poppins-Light", size: 26))
                                .foregroundColor(Color(UIColor(named: "PozGray")!))
                            Text("Alexandra")
                                .font(Font.custom("Poppins-Medium", size: 26))
                            
                        }
                        
                        Spacer()
                        
                        Button (action:{ self.settings.showSettings.toggle() }) {
                            Image(systemName: "gear")
                                .font(Font.custom("Poppins-Light", size: 26))
                                .foregroundColor(Color(UIColor(named: "PozGray")!))
                        }
                        .sheet(isPresented: $settings.showSettings, content: {
                                SettingsView(settings: self.settings)
                                    .environment(\.managedObjectContext, self.moc)
                        })
                        
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                BookView(settings: settings, tabIndex: $tabIndex, isAnimating: $bookOpenAnimation).environment(\.managedObjectContext, self.moc)
                
                if !bookOpenAnimation {
                    PromptsViewB().environment(\.managedObjectContext, self.moc)
                }
                
                Spacer()


            }
            // settings modal sheet
            .preferredColorScheme((settings.darkMode == true ? (.dark) : (.light)))
            .padding(.top, 60).padding(.bottom, 30)
            .background(Color(UIColor(named: "HomeBG")!))
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}
