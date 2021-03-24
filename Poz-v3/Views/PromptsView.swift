//
//  PromptsView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/23/21.
//

import SwiftUI

struct PromptsView: View {
    let prompts:[Prompt] = [
        Prompt(name: "Gratitude", color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), emoji: "🤘🏼", prompt: "What made you smile today?"),
        Prompt(name: "Bro", color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), emoji: "🤘🏼", prompt: "What made you smile today?"),
        Prompt(name: "Yo", color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), emoji: "🤘🏼", prompt: "What made you smile today?"),
        Prompt(name: "Hey", color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), emoji: "🤘🏼", prompt: "What made you smile today?"),
    ]
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack (spacing: 0) {
                Text("Start with a ")
                    .font(Font.custom("Poppins-Light", size: 24))
                    .foregroundColor(Color(UIColor(named: "PozGray")!))
                Text("prompt")
                    .font(Font.custom("Poppins-Medium", size: 24))
                
            }.padding()
            
            
            ScrollView (.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .center, spacing: 10) {
//                    ForEach(0...9, id: \.self) { index in
//                        VStack {
//                            Text("Rant \(index)")
//                                .font(Font.custom("Poppins-Medium", size: 22))
//                            Text("💢")
//                                .font(Font.custom("Blueberry Regular", size: 52))
//                        }
//                        .frame(width: (UIScreen.main.bounds.width/2 -  30), height: 200, alignment: .center)
//                        .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
//                        .cornerRadius(10.0)
//
//                    }
                    ForEach(prompts, id: \.self) {
//                        ZVStack {
                            Text($0.name)
                                .font(Font.custom("Poppins-Medium", size: 22))
                            Text($0.emoji)
                                .font(Font.custom("Blueberry Regular", size: 52))
//                        }
                    }
                    .cornerRadius(5)
                    .padding()
                    
                }.padding(.leading, 20)
                .padding(.trailing, 20)
            }
        }
    }
}

struct PromptsView_Previews: PreviewProvider {
    static var previews: some View {
        PromptsView()
    }
}
