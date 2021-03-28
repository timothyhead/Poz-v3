import SwiftUI

struct Tag : Hashable {
    var name : String
    var color : Color
}

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
    
    @State var tagEntrySheetShowing = false;
    @State var selectedTag: Tag = Tag(name: "", color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)))
    @State var selectedColor = ""
    
    @State var menuOpen = false

    @Environment(\.colorScheme) var colorScheme
    
    @Binding var tabIndex: Int
    
    
    @State private var emojiPickerShowing: Bool = false;
    @State private var addPromptShowing: Bool = false;
    

    let note: Note
    
    let tags:[Tag] = [Tag(name: "", color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))),  Tag(name: "✅ To do", color: Color(#colorLiteral(red: 0.6578102112, green: 0.8591415286, blue: 0.673274219, alpha: 1))), Tag(name: "💭 Idea", color: Color(#colorLiteral(red: 0.8458583951, green: 0.8536861539, blue: 0, alpha: 0.7509899013))), Tag(name: "💢 Rant", color: Color(#colorLiteral(red: 0.9069923162, green: 0.5071092248, blue: 0.4630813003, alpha: 0.4949279179))), Tag(name: "🙏🏻 Gratitude", color: Color(#colorLiteral(red: 0.873713553, green: 0.7492058873, blue: 0.5602819324, alpha: 1))), Tag(name: "📜 Story", color: Color(#colorLiteral(red: 0.6360311508, green: 0.6086863279, blue: 0.8723474145, alpha: 1))), Tag(name: "📝 Note to Self", color: Color(#colorLiteral(red: 0.5947418809, green: 0.8605783582, blue: 0.8334261179, alpha: 1)))]
    
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
//                .padding(.horizontal, 20)
                
            
            Divider()
                .foregroundColor(Color.primary)
                .padding(.horizontal, 20)
                .padding(.bottom, 3)
            
            //text input
            VStack {
                ScrollView {
                    
                    // text input
                    VStack (alignment: .leading) {
                        Text(selected)
                            .font(Font.custom("Poppins-Regular", size: 48))
                            .padding(.bottom, -20)
                        
                        GrowingTextInputView(text: $message, placeholder: "What's on your mind?")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: message) { value in
                        
                        if (message != "") {
                            
                            note.id = UUID() //create id
                            note.note = "\(message ?? "")" //input message
                            note.createdAt = date //actual date to sort
                            note.date = "\(dateString)" //formatted date to sort
                            note.emoji = "\(selected)" // emoji
                            note.tag = "\(selectedTag.name)"

                            try? self.moc.save() //save inputted values
                        }
                    }
                    .onChange(of: selected) { value in
                        if (message != "") {
                            
                            note.id = UUID() //create id
                            note.note = "\(message ?? "")" //input message
                            note.createdAt = date //actual date to sort
                            note.date = "\(dateString)" //formatted date to sort
                            note.emoji = "\(selected)" // emoji
                            note.tag = "\(selectedTag.name)"

                            try? self.moc.save() //save inputted values
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
                if message == "" {
                    
                }
                else if message != "" {
                    try? self.moc.save()
                    message = ""
                    selected = ""
                    emojiPickerShowing = false
                    addPromptShowing = false
                }
            }
                

            if emojiPickerShowing {
                EmojiPicker(selectedIndex: $selectedIndex, selected: $selected)
                    .padding(.bottom, 50)
            }
                
            if addPromptShowing {
                PromptsViewC()
                    .padding(.bottom, 50)
            }
            
            

                
            HStack (spacing: 0) {
                
                EmojiButton(emojiPickerShowing: $emojiPickerShowing)
                
                
                SwiftSpeechButtonView(output: $tempText)
                    .onChange (of: tempText) { value in
                        print(value)
                        message = tempText
                    }
                    .animation(.easeOut)
//                    .animation(.interpolatingSpring(
//                       mass: 1,
//                       stiffness: 200,
//                       damping: 10,
//                       initialVelocity: 0
//                    ))

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
                    .rotationEffect(emojiPickerShowing ? .degrees(-25) : .degrees(0))
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
//                        .rotationEffect(addSpecialShowing ? .degrees(25) : .degrees(0))
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

