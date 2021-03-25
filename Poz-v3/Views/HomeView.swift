//
//  HomeVIew.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/23/21.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var tabIndex: Int
    
    @State var bookOpenAnimation = false
    @State var prevPostsShowing = false
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            
            VStack (alignment: .leading, spacing: 40) {
                
                //top menu
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
                    
                    Button (action:{ prevPostsShowing.toggle() }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(Font.custom("Poppins-Light", size: 26))
                            .foregroundColor(Color(UIColor(named: "PozGray")!))
                    }
                    .sheet(isPresented: $prevPostsShowing, content: { NotesListView() })
                    
                    
                    Button (action:{ self.settings.showSettings.toggle() }) {
                        Image(systemName: "gear")
                            .font(Font.custom("Poppins-Light", size: 26))
                            .foregroundColor(Color(UIColor(named: "PozGray")!))
                    }
                    .sheet(isPresented: $settings.showSettings, content: { SettingsView(settings: self.settings) })
                }
                .padding(.horizontal, 20)
                
                
                
                Spacer()
                
                //Book Block
                VStack {
                    VStack {
                        
                        //book
                        Button( action: {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                tabIndex = 1
//                            }
                            
                            
                            
                        }) {
                            ZStack {
                                Image("book").resizable()
                                    .frame(width: 180, height: 250)
                                    .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 5, x: 0.0, y: 10)
                                    .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 20, x: 0.0, y: 15)
                                
                                VStack {
                                    Text("Kish's Journal")
                                        .font(Font.custom("Blueberry Regular", size: 20))
                                        .foregroundColor(Color(.white))
                                    Text("🤘🏼")
                                        .font(Font.custom("Blueberry Regular", size: 52))
                                        .foregroundColor(Color(.white))
                                    
                                    
                                }
                                
                            }
                            .padding(.bottom, 10)
                        }
                        
                        //book details and edit button
                        HStack (spacing: 0) {
                            Text("Last updated: ")
                                .font(Font.custom("Poppins-Light", size: 16))
                                .foregroundColor(Color(UIColor(named: "PozGray")!))
                            Text("3/3/21")
                                .font(Font.custom("Poppins-Medium", size: 16))
                            
                            Button( action: {} ) {
                                Image(systemName: "pencil")
                                    .font(Font.custom("Poppins-Medium", size: 20))
                                    .foregroundColor(Color(UIColor(named: "PozGray")!))
                                    .padding(.leading, 14)
                            }
                        }
                    }
                   
                }
                .frame(width: UIScreen.main.bounds.width)
                
                PromptsViewB()
//
                //Chart Block
                Button( action: {} ) {
                    smallGoalView()
                } // .padding(.top, 25)
                
//                Divider().padding()
                
                //prompt selector
//                PromptsView()
//                DashboardView(settings: self.settings)

            }
            // settings modal sheet
            .preferredColorScheme((settings.darkMode == true ? (.dark) : (.light)))
            .padding(.top, 60)
        }
        .background(Color(UIColor(named: "HomeBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}
