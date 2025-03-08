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
            
            
            
            Spacer()
        }
       // .padding(.top, -35)
        
    }
}

struct FeedbackButton_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackButton()
    }
}
