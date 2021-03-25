//
//  PromptsView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/23/21.
//

import SwiftUI

//prompt object
struct Prompt : Hashable {
    var name : String
    var color : Color
    var emoji : String
    var prompt : String
    var index : Int
}

//prompt card
struct PromptCard : View {
    
    var prompt: Prompt
    @State var shadowVal: CGFloat = 5.0
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button (action: {}) {
            VStack {
                Text(prompt.name)
                    .font(Font.custom("Poppins-Medium", size: 22))
                    .foregroundColor(.black)

                Text(prompt.emoji)
                    .font(Font.custom("Blueberry Regular", size: 52))
                    .foregroundColor(.black)
            }
            
            .frame(width: (UIScreen.main.bounds.width/2 -  30), height: 200, alignment: .center)
            .background(prompt.color)
            .cornerRadius(10.0)
            .padding()
        }
        .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5910246267)) : Color(#colorLiteral(red: 0.8734936118, green: 0.8683015704, blue: 0.8774850965, alpha: 1))), radius: shadowVal, x: 0, y: shadowVal)
    }
}

//prompt list
struct PromptsView: View {
    
    //create prompts
    let prompts:[Prompt] = [
        Prompt(name: "Idea", color: Color(#colorLiteral(red: 0.7816649079, green: 0.9041231275, blue: 1, alpha: 1)), emoji: "💡", prompt: "What made you smile today?", index: 1),
        Prompt(name: "Note to self", color: Color(#colorLiteral(red: 1, green: 0.8404197693, blue: 0.8131812215, alpha: 1)), emoji: "📝", prompt: "What made you smile today?", index: 2),
        Prompt(name: "Reflection", color: Color(#colorLiteral(red: 0.8020336032, green: 0.77568084, blue: 1, alpha: 1)), emoji: "🔮", prompt: "What made you smile today?", index: 3),
        Prompt(name: "Drawing", color: Color(#colorLiteral(red: 1, green: 0.9204289913, blue: 0.7399825454, alpha: 1)), emoji: "✒", prompt: "What made you smile today?", index: 4),
        
        Prompt(name: "Photo", color: Color(#colorLiteral(red: 0.8121860623, green: 1, blue: 0.8244165182, alpha: 1)), emoji: "🤳", prompt: "What made you smile today?", index: 5),
        Prompt(name: "Brain Dump", color: Color(#colorLiteral(red: 0.8869524598, green: 0.9502753615, blue: 1, alpha: 1)), emoji: "💭", prompt: "What made you smile today?", index: 6),
        Prompt(name: "Vent", color: Color(#colorLiteral(red: 1, green: 0.8935509324, blue: 0.8957810998, alpha: 1)), emoji: "💢", prompt: "What made you smile today?", index: 7),
        Prompt(name: "Gratitude", color: Color(#colorLiteral(red: 1, green: 0.8794577122, blue: 1, alpha: 1)), emoji: "🙏🏾", prompt: "What made you smile today?", index: 8),
        Prompt(name: "Decompress", color: Color(#colorLiteral(red: 0.9080274105, green: 0.920806706, blue: 1, alpha: 1)), emoji: "🔮", prompt: "What made you smile today?", index: 9)
    ]
    
    var body: some View {
        VStack (alignment: .leading) {
            
            //start with a prompt text
            HStack (spacing: 0) {
                Text("Start with a ")
                    .font(Font.custom("Poppins-Light", size: 24))
                    .foregroundColor(Color(UIColor(named: "PozGray")!))
                Text("prompt")
                    .font(Font.custom("Poppins-Medium", size: 24))
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, -10)
            
            //hstack of two vertical columns
            HStack (spacing: -10) {
                
                Spacer()
                
                //all odd index prompts
                VStack(alignment: .center, spacing: -20) {
                    
                    ForEach(prompts, id: \.self) { prompt in
                        if (prompt.index % 2 == 1) {
                            PromptCard(prompt: prompt)
                        }
                    }
                    .cornerRadius(5)
                    
                }
                
                //all even index prompts
                VStack(alignment: .center, spacing: -20) {
                    
                    ForEach(prompts, id: \.self) { prompt in
                        if (prompt.index % 2 == 0) {
                            PromptCard(prompt: prompt)
                        }
                    }
                    .cornerRadius(5)
                    
                }
                
                Spacer()
            }
        }
    }
}

struct PromptsViewB: View {
    
    //create prompts
    let prompts:[Prompt] = [
        Prompt(name: "Idea", color: Color(#colorLiteral(red: 0.7816649079, green: 0.9041231275, blue: 1, alpha: 1)), emoji: "💡", prompt: "What made you smile today?", index: 1),
        Prompt(name: "Note to self", color: Color(#colorLiteral(red: 1, green: 0.8404197693, blue: 0.8131812215, alpha: 1)), emoji: "📝", prompt: "What made you smile today?", index: 2),
        Prompt(name: "Reflection", color: Color(#colorLiteral(red: 0.8020336032, green: 0.77568084, blue: 1, alpha: 1)), emoji: "🔮", prompt: "What made you smile today?", index: 3),
        Prompt(name: "Drawing", color: Color(#colorLiteral(red: 1, green: 0.9204289913, blue: 0.7399825454, alpha: 1)), emoji: "✒", prompt: "What made you smile today?", index: 4),
        
        Prompt(name: "Photo", color: Color(#colorLiteral(red: 0.8121860623, green: 1, blue: 0.8244165182, alpha: 1)), emoji: "🤳", prompt: "What made you smile today?", index: 5),
        Prompt(name: "Brain Dump", color: Color(#colorLiteral(red: 0.8869524598, green: 0.9502753615, blue: 1, alpha: 1)), emoji: "💭", prompt: "What made you smile today?", index: 6),
        Prompt(name: "Vent", color: Color(#colorLiteral(red: 1, green: 0.8935509324, blue: 0.8957810998, alpha: 1)), emoji: "💢", prompt: "What made you smile today?", index: 7),
        Prompt(name: "Gratitude", color: Color(#colorLiteral(red: 1, green: 0.8794577122, blue: 1, alpha: 1)), emoji: "🙏🏾", prompt: "What made you smile today?", index: 8),
        Prompt(name: "Decompress", color: Color(#colorLiteral(red: 0.9080274105, green: 0.920806706, blue: 1, alpha: 1)), emoji: "💤", prompt: "What made you smile today?", index: 9)
    ]
    
    var body: some View {
        VStack (alignment: .leading) {
            
//            //start with a prompt text
//            HStack (spacing: 0) {
//                Text("prompts")
//                    .font(Font.custom("Poppins-Light", size: 16)) 
//            }
//            .padding(.horizontal, 20)
//            .padding(.bottom, -10)
            

            ScrollView (.horizontal, showsIndicators: false)  {
                HStack (spacing: 10) {
                    ForEach(prompts, id: \.self) { prompt in
                        
                        
//                            PromptCard(prompt: prompt)
                        Button (action: {}) {
                            ZStack {
                                Circle().frame(width: 50, height: 50).foregroundColor(prompt.color)
                                Text(prompt.emoji)
                            }
                        }
                        
                    }
                }.padding()
            }
        }
    }
}


