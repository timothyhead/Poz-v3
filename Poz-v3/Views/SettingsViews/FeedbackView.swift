//
//  FeedbackView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/30/21.
//

import SwiftUI

struct FeedbackView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button (action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                        .bold()
                }
            }
            .padding()
            
            WebView(link: "https://78dxgd9o34y.typeform.com/to/bpax2l9N")
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
