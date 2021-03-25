//
//  ContentView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/23/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var settings = SettingsModel()
    @Environment(\.colorScheme) var colorScheme
    @GestureState var pressed = false
    
    @State var tabIndex = 0
    
    @State var pop: CGFloat = 1.0
    var body: some View {
        VStack {
        
            if tabIndex == 0 {
                HomeView(settings: self.settings, tabIndex: $tabIndex)
                
            } else  if tabIndex == 1 {
                ZStack {
                    addNoteView()

                        ZStack (alignment: .center) {
                            Circle()
                                .trim(from: (pressed ? 0 : 0.99), to: 1.0)
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 10 * pop, lineCap: .round, lineJoin: .round))
                                .rotationEffect(.degrees(90.0))
                                .frame(width: 70, height: 70)
                                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                                
                                .foregroundColor(Color(UIColor(named: "PozBlue")!))

                                ZStack {
                                    Circle()
                                        .frame(width: (self.pressed ? 70 : 80), height: 80)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

                                    Image(systemName: (self.tabIndex == 0 ? "house.fill" : "house")).resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.9333333333, alpha: 1)) : Color(#colorLiteral(red: 0.1514667571, green: 0.158391118, blue: 0.1616251171, alpha: 1)))
                                    
                                }
                                .gesture(
                                    LongPressGesture(minimumDuration: 1.3)
                                        .updating($pressed) { currentstate, gestureState, transaction in
                                            transaction.animation = Animation.easeInOut(duration: 1)
                                            gestureState = currentstate
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                print("hey")
                                                withAnimation(.spring()) {
                                                    pop = 2
                                                }
                                            }
                                        }
                                        .onEnded { value in
                                            self.tabIndex = 0
                                            pop = 1
                                        }
                                ).animation(.easeInOut(duration: 1.0))
                                
                        }
                        .offset(x: (UIScreen.main.bounds.width/2 - 60), y: (UIScreen.main.bounds.height/2 - 72))
                }
            }
            
            Spacer()
//            TabsView(index: $tabIndex, settings: self.settings)
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

