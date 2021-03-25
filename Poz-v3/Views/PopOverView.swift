//
//  PopOverView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/24/21.
//

import SwiftUI

struct PopOverMenu: View {
    var body: some View {
        
        VStack (alignment: .leading, spacing: 18) {
            Button (action: {}) {
                HStack (spacing: 15){
                    Image(systemName: "house")
                    Text("Photo")
                }
            }
            
            Divider()
            
            Button (action: {}) {
                HStack (spacing: 15){
                    Image(systemName: "house")
                    Text("Drawing")
                }
            }
            
            Divider()
            
            Button (action: {}) {
                HStack (spacing: 15){
                    Image(systemName: "house")
                    Text("Speech to Text")
                }
            }
            
            Divider()
            
            Button (action: {}) {
                HStack (spacing: 15){
                    Image(systemName: "house")
                    Text("Prompts")
                }
            }
        }
        .frame(width: 150)
        .foregroundColor(.black)
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}


struct PopOverView: View {
    
    @Binding var menuOpen: Bool
    
    @State var buttonSpacing: CGFloat = -60
    
    var body: some View {
        
        VStack (alignment: .leading) {
            Spacer()
            
                if menuOpen {
                    NoteButtonsView(buttonSpacing: $buttonSpacing)
                }
            
            HStack {
                
                Button (action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        menuOpen.toggle()
                        
                    }
                    withAnimation(.easeOut(duration: 3)) {
                        if (buttonSpacing == -60) {
                            buttonSpacing = 30
                        } else if (buttonSpacing == 30) {
                            buttonSpacing = -60
                        }
                    }
                }) {
                    ZStack (alignment: .center) {
                        Circle().frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        Image(systemName: "sparkles")
                            .font(.system(size: 40))
                            .foregroundColor(.black)
                    }
                }
                
                Spacer()
            }
            
        }.padding()
       
    }
}
