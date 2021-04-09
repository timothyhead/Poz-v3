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
//            WebView(link: "https://78dxgd9o34y.typeform.com/to/bpax2l9N")
            WebView(link: "https://forms.gle/4SWfHXyq5KKaUbNR7")
//                .foregroundColor(Color(UIColor(named: "PozGray")!))PozYellow
            Button( action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Close")
                    .font(Font.custom("Poppins-Regular", size: 20))
            }.padding()
        }
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
