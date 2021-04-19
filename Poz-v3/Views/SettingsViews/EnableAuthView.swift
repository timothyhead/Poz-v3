//
//  EnableAuthView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 4/18/21.
//

import SwiftUI

struct EnableAuthViewOnboard: View {
    
    @State var canAuthenticate = true
    @State var isAuthenticateOn: Bool = true
    @Binding var moveForward: Bool
    
    var body: some View {
        
        VStack {
            VStack {
                Text("Secure your journal")
                        .font(Font.custom("Blueberry", size: 28))
                        .foregroundColor(.primary)
                Text("Poz is YOUR personal journal, secure it using Face or Touch ID so only you can access your entries")
                        .font(Font.custom("Poppins-Light", size: 18))
                        .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
                
            }
            .padding()
        
            if canAuthenticate {
                if !moveForward {
                VStack {
                    Button(action: {
                        AuthenticationModel(isUnlocked: $moveForward).authenticate()
                        isAuthenticateOn = true
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 310, height: 60)
                                .foregroundColor(Color(UIColor(named: "PozYellow")!))
                                .cornerRadius(100)
                            
                                    
                            Text("Enable Face/Touch ID")
                                .font(Font.custom("Poppins-Regular", size: 18))
                                .foregroundColor(Color.black)
                        }
                    }
                    
                    Button(action: {
                        moveForward = true
                        isAuthenticateOn = false
                    }) {
                        Text("Don't secure my journal")
                            .font(Font.custom("Poppins-Regular", size: 16))
                    }
                    .padding(.top, 20)
                     
                }
                .padding(.top, 100)
            } else {
                VStack {
                    Text("✅")
                        .font(Font.custom("Poppins-Light", size: 36))
                        .padding(.bottom, 6)
                    Text(isAuthenticateOn ? "Authentication set up, you can change this in settings later" : "No authentication selected, you can change this in settings later.")
                        .font(Font.custom("Poppins-Light", size: 18))
                        .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
                }
                .padding(.horizontal, 20)
                .padding(.top, 100)
            }
            } else {
                Text("...Actually, it looks like your device doesn't support authentication – that's alright! Go ahead and click next.")
                        .font(Font.custom("Poppins-Light", size: 18))
                    .foregroundColor(Color.primary)
                    .onAppear() {
                        moveForward = true
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
            }
            
            Spacer()
        }
        .padding(.top, 100)
        .multilineTextAlignment(.center)
        .onAppear() {
            canAuthenticate = AuthenticationModel(isUnlocked: $moveForward).canUseAuthentication()
        }
    }
}
