//
//  FeedbackButton.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/28/21.
//

import SwiftUI

struct FeedbackButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var feedbackFormShowing = false
    
    var body: some View {
        HStack (alignment: .center) {
            
            Spacer()
            
            Button (action: {
                feedbackFormShowing.toggle()
//                print("setting default value")
//                UserDefaults(suiteName: "Poz")!.set("Hey Kish", forKey: "test")
            }) {
                HStack (alignment: .center, spacing: 10) {
                    Text("Got feedback? 💭")
                        .font(Font.custom("Poppins-Light", size: 16))
                        .foregroundColor(.primary)
                }
                .frame(width: 200, height: 35)
                .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.1833810806, green: 0.1842366755, blue: 0.1863035262, alpha: 1)) : Color(#colorLiteral(red: 0.9298859239, green: 0.9341893792, blue: 0.9447082877, alpha: 1)))
                .cornerRadius(20)
            }
            
            Spacer()
        }
       // .padding(.top, -35)
        .sheet(isPresented: $feedbackFormShowing, content: {})
    }
}

struct FeedbackButton_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackButton()
    }
}
