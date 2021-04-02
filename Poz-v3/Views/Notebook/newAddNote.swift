import SwiftUI

struct newAddNote: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    @ObservedObject var settings: SettingsModel
    
    //vars
    @State private var message: String?
    @State private var emoji: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    @State private var noteSelfTempText: String = ""
    @State private var swiftSpeechTempText: String = ""

    @State var selected = ""
    @State private var selectedIndex: Int = 0
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    
    @State private var emojiPickerShowing: Bool = false;
    @State private var addPromptShowing: Bool = false;

    @State var noteToSelfNotification = Date()
    @State var noteToSelfRandomTime = false

    let note: Note  // = Note(context: self.moc)

    @Binding var promptSelectedIndex: Int
    
    @State var dynamicPrompt = ""
    
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
    
    let introspectPrompts : [String] = [
        "My favorite way to spend the day is...",
        "If I could talk to my teenage self, the one thing I would say is...",
        "The two moments I’ll never forget in my life are... (Describe them in great detail, and what makes them so unforgettable.)",
        "Make a list of 30 things that make you smile.",
        "Write about a moment experienced through your body. Making breakfast, going to a party, having a fight, an experience you’ve had or you imagine for your character. Leave out thought and emotion, and let all information be conveyed through the body and senses.",
        "The words I’d like to live by are...",
        "I couldn’t imagine living without..",
        "When I’m in pain—physical or emotional—the kindest thing I can do for myself is...",
        "Make a list of the people in your life who genuinely support you, and whom you can genuinely trust. Then, make time to hang out with them...",
        "What does unconditional love look like for you?...",
        "What things would you do if you loved yourself unconditionally? How can you act on these things, even if you’re not yet able to love yourself unconditionally?...",
        "I really wish others knew this about me...",
        "Name what is enough for you.",
        "If my body could talk, it would say...",
        "Name a compassionate way you’ve supported a friend recently. Then, write down how you can do the same for yourself.",
        "What do you love about life?",
        "What always brings tears to your eyes? (As Paulo Coelho has said, “Tears are words that need to be written.”)",
        "Write about a time when your work felt real, necessary and satisfying to you, whether the work was paid or unpaid, professional or domestic, physical or mental.",
        "Write about your first love—whether it’s a person, place or thing.",
        "Using 10 words, describe yourself.",
        "What’s surprised you the most about your life or life in general?",
        "What can you learn from your biggest mistakes?",
        "I feel most energized when...",
        "Write a list of questions to which you urgently need answers.",
        "Make a list of everything that inspires you—whether books, websites, quotes, people, paintings, stores, or stars in the sky.",
        "What’s one topic you need to learn more about to help you live a more fulfilling life? (Then, follow through and learn more about that topic.)",
        "I feel happiest in my skin when...",
        "Make a list of everything you’d like to say no to.",
        "Make a list of everything you’d like to say yes to.",
        "Write the words you need to hear."
    ]
    
    var selectedPrompt : Prompt {
        switch promptSelectedIndex {
        
        case 0:
            return Prompt(name: "Simple", color: Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), emoji: "🗒️", subtext: "Just a plain blank plage", index: 0, prompt: "")
        case 1:
           return Prompt(name: "Note to self", color: Color(#colorLiteral(red: 0.7467747927, green: 1, blue: 0.9897406697, alpha: 1)), emoji: "📪", subtext: "Gets sent to you later", index: 1, prompt: "Leave yourself a note, reminder, or encourage your future self.")
        case 2:
           return Prompt(name: "Reflection", color: Color(#colorLiteral(red: 1, green: 0.8737214208, blue: 1, alpha: 1)), emoji: "🔮", subtext: "Questions for introspection", index: 2, prompt: "If this were the last day of my life, would I have the same plans for today?")
        case 3:
           return Prompt(name: "Vent", color: Color(#colorLiteral(red: 1, green: 0.8275836706, blue: 0.8228347898, alpha: 1)), emoji: "💢", subtext: "Autodeletes at later date", index: 3, prompt: "Let it all out, don't hold back.")
        case 4:
           return Prompt(name: "Gratitude", color: Color(#colorLiteral(red: 1, green: 0.8277564049, blue: 0.6865769625, alpha: 1)), emoji: "🙏🏾", subtext: "Open prompts for appreciation", index: 4, prompt: "Write about 3 things you’re grateful for today.")
            
        default:
            return Prompt(name: "", color: Color(#colorLiteral(red: 0.7467747927, green: 1, blue: 0.9897406697, alpha: 1)), emoji: "X", subtext: "", index: 0, prompt: "")
        }
    }
    
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
                    dateString = dateFormatter.string(from: (note.createdAt ?? date) as Date)
                }
//                .onChange(of: dateString) {
//                    note.createdAt = dateString
//                }
                
            Divider()
                .foregroundColor(Color.primary)
                .padding(.horizontal, 20)
                .padding(.bottom, 3)
            
            //text input
            VStack {
                ScrollView {
                    
                    // body content
                    VStack (alignment: .leading) {
                        
                        //show emoji
                        
                        
                        if note.emoji != "" {
                        Text(selected)
                            .font(Font.custom("Poppins-Regular", size: 48))
                            .padding(.bottom, -20)
                            .onAppear() {
                                selected = note.emoji ?? ""
                            }
                        }
                        else {
                            Text((selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") ? selected : selectedPrompt.emoji)
                                .font(Font.custom("Poppins-Regular", size: 48))
                                .padding(.bottom, -20)
                                .onChange(of: selectedPrompt.emoji) { value in
                                    note.emoji = selected
                                }
                        }
                        
//                        Text(note.note ?? "no note")
                        
                        //text input
                        GrowingTextInputView(text: $message, placeholder: "Tap here to begin typing")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .padding(.top, 8)
                            .onAppear() {
//                                print(note.note ?? "empty")
                                message = note.note
                            }
                        
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: message) { value in
                        if (message != "") {
//                            saveNoteB()
//                            note.note = message
                        }
                    }
                    .onChange(of: selected) { value in
                        if (message != "") {
//                            saveNoteB()
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
                if promptSelectedIndex != 1 {
                    //remove all notifications with the same message
                    UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                       var identifiers: [String] = []
                       for notification:UNNotificationRequest in notificationRequests {
                        if notification.identifier == "Note to Self \(message ?? "No message")" {
                              identifiers.append(notification.identifier)
                           }
                       }
                       UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                    }
                    
                }

//                if (message != "") {
//                    showing = false
//                    saveNoteB()
//                    try? self.moc.save()
//                    print("saved")
//                    resetNote()
//                    showing = true
//                }
                
                if (message != "" && message != settings.welcomeText) {
                saveNoteB()
                }
            }

            if emojiPickerShowing {
                EmojiPicker(selectedIndex: $selectedIndex, selected: $selected)
                    .padding(.bottom, 50)
            }
                
            if addPromptShowing {
                PromptsViewC(promptIndex: $promptSelectedIndex)
                    .padding(.bottom, 50)
            }
            
            HStack (spacing: 0) {
                
                if (selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") {
                    EmojiButton(emojiPickerShowing: $emojiPickerShowing)
                }
                
                
                SwiftSpeechButtonView(output: $swiftSpeechTempText)
                    .onChange (of: swiftSpeechTempText) { value in
                        message = swiftSpeechTempText
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
    
    func saveNoteB () {
        
        if message != "" && message != nil { // && promptSelectedIndex != 3
            print("hello")
//            let note = Note(context: self.moc)
            
            note.id = UUID() //create id
            
//            if promptSelectedIndex == 3 {
//
//                note.note = message ?? ""
//
//                note.emoji = (selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") ? selected : selectedPrompt.emoji  // emoji
//                note.prompt = selectedPrompt.prompt
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                    note.note = "Message autodeleted" //input message
//                    note.emoji = "🗑"  // emoji
//                    note.prompt = ""
//                    try? self.moc.save()
//                }
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                    note.note = "..." //input message
//                    note.emoji = ""  // emoji
//                    note.prompt = ""
//                    try? self.moc.save()
//                }
//
//            } else {
                note.note = message ?? "" //input message
//            }
            
//            note.createdAt = date //actual date to sort
//            note.date = dateString //formatted date to sort
//            note.emoji = (selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") ? selected : selectedPrompt.emoji  // emoji
            note.emoji = selected
            note.prompt = selectedPrompt.prompt
            
            if (promptSelectedIndex == 1) {
                note.helpText = "Note will be sent back to you"
            }
            if (promptSelectedIndex == 3) {
                note.helpText = "Note will be autodeleted"
            }

            try? self.moc.save()
//            print(message ?? "bro")
        }
    }
    
//    func resetNote () {
//        message = ""
//        selected = ""
//        emojiPickerShowing = false
//        addPromptShowing = false
//        promptSelectedIndex = 0
//    }
    
    func createNotification (message: String, dateIn: Date) {
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Note to self configured")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        
        //remove all notifications with the same message
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
            if notification.identifier == "Note to Self \(message )" {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        
        let content = UNMutableNotificationContent()
        
        content.title = "Note to Self"
        content.subtitle = message
        content.sound = UNNotificationSound.default
        
        let date = dateIn
        let calendar = Calendar.current
        
        
        var dateComponents = DateComponents()
        
        dateComponents.hour = calendar.component(.hour, from: date)
        dateComponents.minute = calendar.component(.minute, from: date)
        
        //daily notification
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: String("Note to Self \(message)"), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        
        print("Notification created to print \(message) at \(dateIn)")
    }
    
    func generateRandomDate(daysForward: Int)-> Date? {
        let day = arc4random_uniform(UInt32(daysForward))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)
        
        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(day - 1)
        offsetComponents.hour = Int(hour)
        offsetComponents.minute = Int(minute)
        
        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
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
    }
}


//struct noteToSelfNotificationPicker : View {
//
//
//    @Binding var message: String
//
//    @State var dateFormatter = DateFormatter();
//
//
//
//
//    var body : some View {
//
//    }
//}
