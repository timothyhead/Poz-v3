//
//  SwipeTutorialView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 4/6/21.
//

import SwiftUI

struct SwipeTutorialView: View {
    @State var show = true
    
    var body: some View {
        
        if show {
            ZStack {
                Image (systemName: "xmark")
                    .foregroundColor(.white)
                    .offset(x: -80, y: -75)
                
                VStack {
                    
                    LottieView(fileName: "swipe-simple")
                        .frame(width: 150, height: 100)
                    Text("Swipe to turn pages")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Light", size: 14))
                    
                }
            }
            .padding(.all, 40)
            .background(Color.black.opacity(0.85))
            .frame(width: 200, height: 190, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .cornerRadius(10)
        }
    }
}

struct SwipeTutorialView_Previews: PreviewProvider {
    
//    @State var boolean = false
    static var previews: some View {
        SwipeTutorialView()
    }
}
