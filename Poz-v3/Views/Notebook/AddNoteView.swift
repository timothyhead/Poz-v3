import SwiftUI

struct addNoteView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    //vars
    @State private var message: String?
    @State private var tempText: String = ""
    @State private var emoji: String = ""

    @State var selected = ""
    @State private var selectedIndex: Int = 0
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @State var menuOpen = false

    @Environment(\.colorScheme) var colorScheme
    
    @Binding var tabIndex: Int
    
    
    @State private var emojiPickerShowing: Bool = false;
    @State private var addPromptShowing: Bool = false;


    let note: Note

    
    @State var promptSelectedIndex = 0
    @State var selectedPrompt = Prompt(name: "", color: Color(#colorLiteral(red: 0.7467747927, green: 1, blue: 0.9897406697, alpha: 1)), emoji: "X", subtext: "", index: 0, prompt: "")

    var body: some View {
        
        ZStack {
            VStack {
                
                HStack {
                    Text("\(dateString)")
                        .font(Font.custom("Poppins-Bold", size: 16))
                        .foregroundColor(Color.primary)
                    
//                    Spacer()
                    
                }.padding(.top, -5)
                .onAppear() {
                       dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
                       dateString = dateFormatter.string(from: date as Date)
                }
                
            Divider()
                .foregroundColor(Color.primary)
                .padding(.horizontal, 20)
                .padding(.bottom, 3)
            
            //text input
            VStack {
                ScrollView {
                    
                    // body content
                    VStack (alignment: .leading) {
                        
                        
                        Text((selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") ? selected : selectedPrompt.emoji)
                            .font(Font.custom("Poppins-Regular", size: 48))
                            .padding(.bottom, -20)
                        
                        if (promptSelectedIndex != 0) {
                            Text("\(selectedPrompt.prompt)")
                                .font(Font.custom("Poppins-Medium", size: 16))
                                .padding(.top, 10)
                                .padding(.bottom, -8)
                                .onChange (of: promptSelectedIndex) { value in
                                    
                                }
                        }
                        
                        
                        GrowingTextInputView(text: $message, placeholder: "Tap to begin typing")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .padding(.top, 8)
                        
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: message) { value in
                        
                        if (message != "") {
                            
                            note.id = UUID() //create id
                            note.note = message ?? "" //input message
                            note.createdAt = date //actual date to sort
                            note.date = dateString //formatted date to sort
                            note.emoji = (selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") ? selected : selectedPrompt.emoji  // emoji
                            note.prompt = selectedPrompt.prompt

//                            try? self.moc.save() //save inputted values
                          
                        }
                    }
                    .onChange(of: selected) { value in
                        if (message != "") {
                            
                            note.id = UUID() //create id
                            note.note = message ?? "" //input message
                            note.createdAt = date //actual date to sort
                            note.date = dateString //formatted date to sort
                            note.emoji = (selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") ? selected : selectedPrompt.emoji  // emoji
                            note.prompt = selectedPrompt.prompt

//                            try? self.moc.save() //save inputted values
                       
                        }
                    }
                    
                    Spacer(minLength: 50)
                }
                
                .padding(.top, -11)
            }
            .onTapGesture {
                hideKeyboard() //hide keyboard when user taps outside text field
            }
            .onAppear() {
                UITextView.appearance().backgroundColor = .clear //make textfield clear
            }
            .onDisappear() {
                if message == "" || message != nil {
                    try? self.moc.save()
                    message = ""
                    selected = ""
                    emojiPickerShowing = false
                    addPromptShowing = false
                    promptSelectedIndex = 0
                    selectedPrompt = Prompt(name: "", color: Color(#colorLiteral(red: 0.7467747927, green: 1, blue: 0.9897406697, alpha: 1)), emoji: "X", subtext: "", index: 0, prompt: "")
                }
            }

            if emojiPickerShowing {
                EmojiPicker(selectedIndex: $selectedIndex, selected: $selected)
                    .padding(.bottom, 50)
            }
                
            if addPromptShowing {
                PromptsViewC(selectedPrompt: $selectedPrompt, promptIndex: $promptSelectedIndex)
                    .padding(.bottom, 50)
            }
            
            HStack (spacing: 0) {
                
                if (selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") {
                    EmojiButton(emojiPickerShowing: $emojiPickerShowing)
                }
                
                
                SwiftSpeechButtonView(output: $tempText)
                    .onChange (of: tempText) { value in
                        message = tempText
                    }
                    .animation(.easeOut)

                PromptsButton(addPromptShowing: $addPromptShowing)
                
                Spacer()
            }
            .padding(.bottom, 40)
            .padding(.horizontal, 20)
                
            }
        }
        .onAppear() {
            
            dateFormatter.dateFormat = "MMM dd, yyyy | h:mm a"
            dateString = dateFormatter.string(from: date as Date)
            
        }
        .padding(.top, 60)
        .background(Color(UIColor(named: "NoteBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
    
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


struct EmojiButton : View {
    
    @Binding var emojiPickerShowing: Bool
    
    var body: some View {
        
        //emoji button
        
        ZStack{
            if emojiPickerShowing {
                Text("Tag with emoji")
                    .font(Font.custom("Poppins-Light", size: 12))
                    .zIndex(-1)
                    .offset(x: 15, y: -35)
                    
            }
            Button(action: { emojiPickerShowing.toggle()}) {
                Text("🎭")
                    .font(.system(size: 30))
            }
        }
        .scaleEffect((emojiPickerShowing ? 1.76 : 1))
        .animation(.easeOut)
//        .animation(.interpolatingSpring(
//           mass: 1,
//           stiffness: 200,
//           damping: 10,
//           initialVelocity: 0
//        ))
//
    }
}


struct PromptsButton : View {
    
    @Binding var addPromptShowing: Bool
    
    var body: some View {
//        ZStack {
            
            //sparkles button
            ZStack{
                if addPromptShowing {
                    Text("Add prompt/action")
                        .font(Font.custom("Poppins-Light", size: 12))
                        .zIndex(-1)
                        .offset(x: 0, y: -35)
                        
                }
                Button(action: { addPromptShowing.toggle() }) {
                    
                    Text("📝")
                        .font(.system(size: 30))
                }
            }
            .scaleEffect((addPromptShowing ? 1.76 : 1))
            .animation(.easeOut)
//            .animation(.interpolatingSpring(
//               mass: 1,
//               stiffness: 200,
//               damping: 10,
//               initialVelocity: 0
//            ))
////        }/
    }
}

//                //emoji putput
//                Text("\(selected)")
//                    .font(.system(size: 16))
//                    .padding(.horizontal, 2)
//
//                // tag button
//                Button (action: {
//                    tagEntrySheetShowing.toggle()
//                }) {
//
//                    if (selectedTag.name == "") {
//                        HStack {
//                            Image(systemName: "tag")
//                                .resizable().frame(width: 20, height: 20)
//                            Text("Tag Entry")
//                                .font(Font.custom("Poppins-Regular", size: 16))
//                        }
//                        .foregroundColor(Color.primary)
//                    } else {
//                        HStack {
//                            Text("\(selectedTag.name)")
//                                .padding(.horizontal, 7)
//                                .padding(.top, 4)
//                                .padding(.bottom, 4)
//                                .background(selectedTag.color)
//                        }
//                        .foregroundColor(Color.primary)
//                        .cornerRadius(5)
//                    }
//
//                }
//                //tag popup
//                .sheet(isPresented: $tagEntrySheetShowing) {
//                    VStack {
//                        Picker("Please choose a color", selection: $selectedTag) {
//                            ForEach(tags, id: \.self) {
//                                Text($0.name)
//                                    .padding(.horizontal, 7)
//                                    .padding(.top, 4)
//                                    .padding(.bottom, 4)
//                                    .cornerRadius(5)
//                                    .background($0.color)
//                            }
//                            .cornerRadius(5)
//                            .padding()
//                        }
//                        Text("You selected: \(selectedTag.name)")
//                    }
//                }
//
//            }
//

