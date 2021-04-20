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
    
    @Binding var promptSelectedIndex: Int
    @Binding var promptSelectedFromHome: Bool
    
    @State var feedbackFormShowing = false
    
    @State var firstTimeShowing = true
    
    @State var dailyGoalSheetShowing = false

    var body: some View {
        
        ZStack {
            
            VStack (alignment: .leading, spacing: 0) {
                
                if !bookOpenAnimation {
                    //top bar
                    HStack (alignment: .top, spacing: 20) {
                        //Hello Text
                        VStack (alignment: .leading, spacing: 0) {
                            Text( timeOfDayOutput() )
                                .font(Font.custom("Poppins-Light", size: 26))
                                .foregroundColor(Color(UIColor(named: "PozGray")!))
                            Text("\(settings.username)")
                                .font(Font.custom("Poppins-Medium", size: 26))
                            
                        }
                        
                        Spacer()
                        
                        Button (action: { feedbackFormShowing.toggle() }) {
                            Text("💬")
                                .font(Font.custom("Poppins-Light", size: 26))
                                .foregroundColor(.primary)
                        }
                        .sheet(isPresented: $feedbackFormShowing, content: { FeedbackView() })
                        
                        Button (action:{ self.settings.showSettings.toggle() }) {
                            Text("⚙️")
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
                
                BookView(settings: settings, tabIndex: $tabIndex, isOpening: $bookOpenAnimation, promptSelectedIndex: $promptSelectedIndex, promptSelectedFromHome: $promptSelectedFromHome).environment(\.managedObjectContext, self.moc)
                
                
                Spacer()
                
                if !bookOpenAnimation {
                    Button (action: { dailyGoalSheetShowing = true }) {
                        barGoalView(settings: settings)
                    }
                    .sheet(isPresented: $dailyGoalSheetShowing) {
                        NotificationsViewPopup(settings: settings)
                    }
                }
            }
            .padding(.top, 60).padding(.bottom, 30)
            .background(Color(UIColor(named: "HomeBG")!))
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .onAppear() {
                promptSelectedIndex = 0
            }

            if (firstTimeShowing) {
                HomeViewTutorial(show: firstTimeShowing)
                    .onAppear() {
                        firstTimeShowing = firstTimeAppearing()

//                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                            withAnimation (.easeOut) {
//                                firstTimeShowing = firstTimeAppearing()
//                            }
//                        }
                    }
            }
        }
        .onTapGesture {
            firstTimeShowing = false
        }
    }
    
    func firstTimeAppearing()->Bool{
        let homeScreendefaults = UserDefaults.standard

        if let firstTimeAppearing = homeScreendefaults.string(forKey: "firstTimeAppearing"){

            print("Screen already launched : \(firstTimeAppearing)")
            return false

        } else {
            
            homeScreendefaults.set(true, forKey: "firstTimeAppearing")
            print("Screen launched first time")
            return true

        }
    }
    
    func timeOfDayOutput () -> String {
        
        let currentTime = Calendar.current.component( .hour, from:Date() )
        
        if (currentTime < 12) {
            return "Good morning,"
        } else if (currentTime >= 12 && currentTime < 17) {
            return "Good afternoon,"
        } else if (currentTime >= 17 && currentTime < 20) {
            return "Good evening,"
        } else {
            return "Good night,"
        }
    }
}
