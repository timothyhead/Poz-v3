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
    var subtext: String
    var index : Int
    var prompt : String
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
        Prompt(name: "Idea", color: Color(#colorLiteral(red: 0.7816649079, green: 0.9041231275, blue: 1, alpha: 1)), emoji: "💡", subtext: "What made you smile today?", index: 1, prompt: ""),
        Prompt(name: "Note to self", color: Color(#colorLiteral(red: 1, green: 0.8404197693, blue: 0.8131812215, alpha: 1)), emoji: "📝", subtext: "What made you smile today?", index: 2, prompt: ""),
        Prompt(name: "Reflection", color: Color(#colorLiteral(red: 0.8020336032, green: 0.77568084, blue: 1, alpha: 1)), emoji: "🔮", subtext: "What made you smile today?", index: 3, prompt: ""),
        Prompt(name: "Drawing", color: Color(#colorLiteral(red: 1, green: 0.9204289913, blue: 0.7399825454, alpha: 1)), emoji: "✒", subtext: "What made you smile today?", index: 4, prompt: ""),
        
        Prompt(name: "Photo", color: Color(#colorLiteral(red: 0.8121860623, green: 1, blue: 0.8244165182, alpha: 1)), emoji: "🤳", subtext: "What made you smile today?", index: 5, prompt: ""),
        Prompt(name: "Brain Dump", color: Color(#colorLiteral(red: 0.8869524598, green: 0.9502753615, blue: 1, alpha: 1)), emoji: "💭", subtext: "What made you smile today?", index: 6, prompt: ""),
        Prompt(name: "Vent", color: Color(#colorLiteral(red: 1, green: 0.8935509324, blue: 0.8957810998, alpha: 1)), emoji: "💢", subtext: "What made you smile today?", index: 7, prompt: ""),
        Prompt(name: "Gratitude", color: Color(#colorLiteral(red: 1, green: 0.8794577122, blue: 1, alpha: 1)), emoji: "🙏🏾", subtext: "What made you smile today?", index: 8, prompt: ""),
        Prompt(name: "Decompress", color: Color(#colorLiteral(red: 0.9080274105, green: 0.920806706, blue: 1, alpha: 1)), emoji: "🔮", subtext: "What made you smile today?", index: 9, prompt: "")
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
//        Prompt(name: "Idea", color: Color(#colorLiteral(red: 0.7816649079, green: 0.9041231275, blue: 1, alpha: 1)), emoji: "💡", prompt: "What made you smile today?", index: 1),
        Prompt(name: "Note to self", color: Color(#colorLiteral(red: 0.7467747927, green: 1, blue: 0.9897406697, alpha: 1)), emoji: "📪", subtext: "What made you smile today?", index: 2, prompt: ""),
        Prompt(name: "Reflection", color: Color(#colorLiteral(red: 1, green: 0.8737214208, blue: 1, alpha: 1)), emoji: "🔮", subtext: "What made you smile today?", index: 3, prompt: ""),
//        Prompt(name: "Drawing", color: Color(#colorLiteral(red: 1, green: 0.9204289913, blue: 0.7399825454, alpha: 1)), emoji: "✒", prompt: "What made you smile today?", index: 4),
        
//        Prompt(name: "Photo", color: Color(#colorLiteral(red: 0.8121860623, green: 1, blue: 0.8244165182, alpha: 1)), emoji: "🤳", prompt: "What made you smile today?", index: 5),
//        Prompt(name: "Brain Dump", color: Color(#colorLiteral(red: 0.8869524598, green: 0.9502753615, blue: 1, alpha: 1)), emoji: "💭", prompt: "What made you smile today?", index: 6),
        Prompt(name: "Vent", color: Color(#colorLiteral(red: 1, green: 0.8275836706, blue: 0.8228347898, alpha: 1)), emoji: "💢", subtext: "What made you smile today?", index: 7, prompt: ""),
        Prompt(name: "Gratitude", color: Color(#colorLiteral(red: 1, green: 0.8277564049, blue: 0.6865769625, alpha: 1)), emoji: "🙏🏾", subtext: "What made you smile today?", index: 8, prompt: ""),
//        Prompt(name: "Decompress", color: Color(#colorLiteral(red: 0.9080274105, green: 0.920806706, blue: 1, alpha: 1)), emoji: "💤", prompt: "What made you smile today?", index: 9)
    ]
    
    var body: some View {
        VStack (alignment: .center) {
            HStack (alignment: .center, spacing: 10) {
                    ForEach(prompts, id: \.self) { prompt in
                        
                        Button (action: {}) {
                            ZStack {
                                Circle().frame(width: 50, height: 50).foregroundColor(prompt.color)
                                Text(prompt.emoji)
                            }
                        }
                        
                        
                    }
                }
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width)

        
    }
}


struct PromptsViewC: View {
    
    @Binding var selectedPrompt: Prompt
    
    let gratitudePrompts : [String] = [
        "Write about 3 things you’re grateful for today.",
        "What did you accomplish today?",
        "Write about a happy memory.",
        "Write about someplace you’ve been that you’re grateful for.",
        "What’s something about your body or health that you’re grateful for?",
        "What’s something that you’re looking forward to?",
        "Look around the room and write about everything you see that you’re grateful for.",
        "How are you able to help others?",
        "What’s an accomplishment you’re proud of?"
    ]
    
    //create prompts
    let prompts:[Prompt] = [
        Prompt(name: "Simple", color: Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), emoji: "🗒️", subtext: "Just a plain blank plage", index: 0, prompt: ""),
        Prompt(name: "Note to self", color: Color(#colorLiteral(red: 0.7467747927, green: 1, blue: 0.9897406697, alpha: 1)), emoji: "📪", subtext: "Gets sent to you later", index: 1, prompt: "Leave yourself a note and send it back to yourself either at a random future date time or a specified one."),
        Prompt(name: "Reflection", color: Color(#colorLiteral(red: 1, green: 0.8737214208, blue: 1, alpha: 1)), emoji: "🔮", subtext: "Questions for introspection", index: 2, prompt: "If this were the last day of my life, would I have the same plans for today?"),
        Prompt(name: "Vent", color: Color(#colorLiteral(red: 1, green: 0.8275836706, blue: 0.8228347898, alpha: 1)), emoji: "💢", subtext: "Autodeletes at later date", index: 3, prompt: "Let it all out, don't hold back. This note will be autodeleted in exactly one week."),
        Prompt(name: "Gratitude", color: Color(#colorLiteral(red: 1, green: 0.8277564049, blue: 0.6865769625, alpha: 1)), emoji: "🙏🏾", subtext: "Open prompts for appreciation", index: 4, prompt: "Write about 3 things you’re grateful for today.")
    ]
    
    @Binding var promptIndex: Int
    
    var body: some View {
        VStack (alignment: .center) {
            VStack (alignment: .leading, spacing: 5) {
                    ForEach(prompts, id: \.self) { prompt in
                        
                        Button (action: {
                            promptIndex = prompt.index
                            selectedPrompt = prompt
//                            if (prompt.index == 4) {
//                                prompt.prompt = gratitudePrompts.randomElement()!
//                            }
                        }) {
                            HStack {
                                
                                
                                ZStack {
                                    Circle().frame(width: 50, height: 50).foregroundColor(prompt.color)
                                    Text(prompt.emoji)
                                }
                                VStack (alignment: .leading) {
                                    Text(prompt.name)
                                        .foregroundColor(Color.primary)
                                    Text(prompt.subtext)
                                        .foregroundColor(Color(UIColor(named: "PozGray")!))
                                }
                                
                                Spacer()
                                
                            }
                            .padding()
                            .background(prompt.index == promptIndex ? Color.black.opacity(0.05) : Color.clear)
                            .cornerRadius(50)
                        }
                        
                        Divider()

                    }
                }
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(UIColor(named: "NoteBG")!))
        .shadow(color: Color.black.opacity(0.25), radius: 50, x: 0, y: -90)
        .animation(.easeOut)

        
    }
}




