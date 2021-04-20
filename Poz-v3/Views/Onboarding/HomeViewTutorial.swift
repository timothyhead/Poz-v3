//
//  HomeViewTutorial.swift
//  Poz-v3
//
//  Created by Kish Parikh on 4/7/21.
//

import SwiftUI

struct HomeViewTutorial: View {
    @State var show = true
    
    var body: some View {
        
        if show {
        ZStack (alignment: .topLeading) {
                Image (systemName: "xmark")
                    .foregroundColor(.white)
                    .offset(x: -20, y: -20)
                
                VStack (alignment: .leading, spacing: 20) {
                    
                    Text("Quick tips:")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Medium", size: 20))
                        .padding(.top, 10)
                    
                    Text("📔 - Click on your journal to open")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Light", size: 16))
                    
//                    Text("📪🔮💢🙏🏾 - Jump into a prompt")
//                        .foregroundColor(.white)
//                        .font(Font.custom("Poppins-Light", size: 16))
                    
                    Text("💬 - Give feedback/ask questions/suggest changes quickly")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Light", size: 16))
                    
                    Text("⚙️ - Change your name, customize your journal, setup notifications, and much more")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Light", size: 16))
                    
                }
            }
            .padding(.all, 40)
            .frame(width: 320, height: 380, alignment: .topLeading)
            .background(Color.black.opacity(0.85))
            .cornerRadius(10)
            
        }
    }
}

//struct HomeViewTutorial_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeViewTutorial()
//    }
//}
