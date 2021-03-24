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
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 20) {
                
                HStack {
                    Spacer()
                    Button (action:{ self.settings.showSettings.toggle() }) {
                        Image(systemName: "gear")
                            .font(Font.custom("Poppins-Light", size: 26))
                            .foregroundColor(Color(UIColor(named: "PozGray")!))
                    }
                }.padding(.trailing, 20).padding(.bottom, -20)
                
                //Hello Text
                HStack (spacing: 0) {
                    Text("Good morning, ")
                        .font(Font.custom("Poppins-Light", size: 26))
                        .foregroundColor(Color(UIColor(named: "PozGray")!))
                    Text("Alexandra")
                        .font(Font.custom("Poppins-Medium", size: 26))
                    
                }.padding()
                
                //Book Block
                VStack {
                    VStack {
                        Button( action: {} ) {
                            ZStack {
                                Image("book").resizable()
                                    .frame(width: 200, height: 280)
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
                .frame(width: UIScreen.main.bounds.width, height: 440)
                .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1514667571, green: 0.158391118, blue: 0.1616251171, alpha: 1)) : Color(#colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.9333333333, alpha: 1)))
                
                
//                Divider().padding()
                
                //Chart Block
                Button( action: {} ) {
                    HStack {
                        Spacer()
                        ZStack {
                            RingView(color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), endVal: 0.5, sizeScale: 1.0)
                            
                            Text("1/2")
                                .font(Font.custom("Poppins-Bold", size: 24))
                                .foregroundColor(Color(UIColor(named: "PozBlue")!))
                        }
                        Text("Entries added today")
                            .foregroundColor(Color.primary)
                            .font(Font.custom("Poppins-Light", size: 18))
                            .padding(.leading, 15)
                        Spacer()
                    }
                }.padding(.top, 15)
                
                Divider().padding()
                
                //prompt selector

            }
            // settings modal sheet
            .sheet(isPresented: $settings.showSettings, content: {
                SettingsView(settings: self.settings)
            })
            .preferredColorScheme((settings.darkMode == true ? (.dark) : (.light)))
            .padding(.top, 60)
            .padding(.bottom, 80)
        }
        .background(Color(UIColor(named: "HomeBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
