import SwiftUI

struct NotePage: View {
    
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
    
//    @Binding var lastModifiedJournalIndex: Int
    
    @State var noteToSelfNotification = Date()
    @State var noteToSelfRandomTime = false
    
    @State private var emojiPickerShowing: Bool = false;
    @State private var addPromptShowing: Bool = false;

    @State var initialText =  ""
    @State var initialEmoji = ""

    let note: Note  // = Note(context: self.moc)

    @Binding var promptSelectedIndex: Int
    
    @State var dynamicPrompt = ""
    
//    @State var defaultPrompt = Prompt(name: "", color: Color(#colorLiteral(red: 0.7467747927, green: 1, blue: 0.9897406697, alpha: 1)), emoji: "", subtext: "", index: 0, prompt: "")
    
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
            return Prompt(name: "", color: Color(#colorLiteral(red: 0.7467747927, green: 1, blue: 0.9897406697, alpha: 1)), emoji: "", subtext: "", index: 0, prompt: "")
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
                    if note.date != "-" {
                        dateString = dateFormatter.string(from: (note.createdAt ?? date) as Date)
                    } else {
                        dateString = note.date ?? "-"
                    }
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
//                        Text((selectedPrompt.emoji == "" || selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") ? selected : selectedPrompt.emoji)
                            
                        
                        Text(selected)
                            .font(Font.custom("Poppins-Regular", size: 48))
                            .padding(.bottom, -20)
                        
                        if dynamicPrompt != "" {
                            Text(dynamicPrompt)
                                .font(Font.custom("Poppins-Bold", size: 16))
                                .padding(.top, 16)
                        }
                        
                        if promptSelectedIndex == 0 {
                        }
                        if promptSelectedIndex == 1 {
                            HStack {
                                Image(systemName: "paperplane")

                                Text("This will be sent back to you")

                            }
                            .foregroundColor(Color.blue)
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .padding(.vertical,5)

                            VStack {

                                Picker(selection: $noteToSelfRandomTime, label: Text("Random or manual time?")) {
                                    Text("Random Time").tag(false)
                                    Text("Manual Time").tag(true)
                                }
                                .font(Font.custom("Poppins-Regular", size: 16))
                                .pickerStyle(SegmentedPickerStyle())

                                if noteToSelfRandomTime {
                                    DatePicker(
                                        "",
                                        selection: $noteToSelfNotification,
                                        displayedComponents: [.date, .hourAndMinute]
                                    )
                                    .font(Font.custom("Poppins-Regular", size: 16))
                                    .onChange (of: noteToSelfNotification) { value in
                                        if message != "" {
                                            createNotification(message: message ?? "", dateIn: noteToSelfNotification)
                                        }
                                    }
                                } else {
                                    Text("This note will return to you sometime in the next week")
                                        .font(Font.custom("Poppins-Regular", size: 0)).opacity(0)
                                        .padding(.bottom, -22)
                                        .onAppear() {
                                            if message != "" {
                                                createNotification(message: message ?? "", dateIn: generateRandomDate(daysForward: 7)!)
                                            }
                                        }
                                        .onChange (of: message) { value in
                                            if message != "" {
                                                createNotification(message: message ?? "", dateIn: generateRandomDate(daysForward: 7)!)
                                            }
                                        }
                                }
                                }
                        }
                        if promptSelectedIndex == 2 {
                        }
                        if promptSelectedIndex == 3 {
                            HStack {
                                Image(systemName: "trash")

                                Text("This will be autodeleted")

                            }
                            .foregroundColor(Color.red)
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .padding(.top, 8)
                        }
                        if promptSelectedIndex == 4 {
                            
                        }
                        
                        
//                        promptContent(promptSelectedIndex: $promptSelectedIndex, settings: settings, dynamicPrompt: $dynamicPrompt, message: $emoji, selectedPrompt: $defaultPrompt)
//                            .onChange(of: defaultPrompt) { value in
//                                print("hi")
//                            }

//                        //show prompt
//                        if (promptSelectedIndex != 0) {
//                            if promptSelectedIndex == 4 {
//                                Text("\(dynamicPrompt)")
//                                    .font(Font.custom("Poppins-Medium", size: 16))
//                                    .padding(.top, 10)
//                                    .padding(.bottom, -8)
//                                    .onAppear() {
//                                        dynamicPrompt = settings.gratitudePrompts.randomElement()!
//                                    }
//                            } else if promptSelectedIndex == 2 {
//                                Text("\(dynamicPrompt)")
//                                    .font(Font.custom("Poppins-Medium", size: 16))
//                                    .padding(.top, 10)
//                                    .padding(.bottom, -8)
//                                    .onAppear() {
//                                        dynamicPrompt = settings.introspectPrompts.randomElement()!
//                                    }
//                            }
//
//                            else {
//                                Text("\(selectedPrompt.prompt)")
//                                    .font(Font.custom("Poppins-Medium", size: 16))
//                                    .padding(.top, 10)
//                                    .padding(.bottom, -8)
//                                    .onAppear() {
//
//                                    }
//                            }
//                        }
//
//                        //if vent selected, autodelete
//                        if promptSelectedIndex == 3 {
//                            HStack {
//                                Image(systemName: "trash")
//
//                                Text("This will be autodeleted")
//
//                            }
//                            .foregroundColor(Color.red)
//                            .font(Font.custom("Poppins-Regular", size: 16))
//                            .padding(.top, 8)
//                        }
//
//
//                        //if note to self selected, show note to self notification options
//                        if (promptSelectedIndex == 1) {
//                            HStack {
//                                Image(systemName: "paperplane")
//
//                                Text("This will be sent back to you")
//
//                            }
//                            .foregroundColor(Color.blue)
//                            .font(Font.custom("Poppins-Regular", size: 16))
//                            .padding(.vertical,5)
//
//                            VStack {
//
//                                Picker(selection: $noteToSelfRandomTime, label: Text("Random or manual time?")) {
//                                    Text("Random Time").tag(false)
//                                    Text("Manual Time").tag(true)
//                                }
//                                .font(Font.custom("Poppins-Regular", size: 16))
//                                .pickerStyle(SegmentedPickerStyle())
//
//                                if noteToSelfRandomTime {
//                                    DatePicker(
//                                        "",
//                                        selection: $noteToSelfNotification,
//                                        displayedComponents: [.date, .hourAndMinute]
//                                    )
//                                    .font(Font.custom("Poppins-Regular", size: 16))
//                                    .onChange (of: noteToSelfNotification) { value in
//                                        if message != "" {
//                                            createNotification(message: message ?? "", dateIn: noteToSelfNotification)
//                                        }
//                                    }
//                                } else {
//                                    Text("This note will return to you sometime in the next week")
//                                        .font(Font.custom("Poppins-Regular", size: 0)).opacity(0)
//                                        .padding(.bottom, -22)
//                                        .onAppear() {
//                                            if message != "" {
//                                                createNotification(message: message ?? "", dateIn: generateRandomDate(daysForward: 7)!)
//                                            }
//                                        }
//                                        .onChange (of: message) { value in
//                                            if message != "" {
//                                                createNotification(message: message ?? "", dateIn: generateRandomDate(daysForward: 7)!)
//                                            }
//                                        }
//                                }
//                            }
//                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        //text input
                        GrowingTextInputView(text: $message, placeholder: "Tap here to begin typing")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .padding(.leading, -4)
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 50)
                }
                
                .padding(.top, -11)
            }
            .onChange(of: promptSelectedIndex) { value in
                if promptSelectedIndex == 0 {
                    dynamicPrompt = ""
                    selected = ""
                }
                if promptSelectedIndex == 1 {
                    dynamicPrompt = "Leave a note or reminder for your future self."
                    selected = "📪"
                }
                if promptSelectedIndex == 2 {
                    dynamicPrompt = settings.introspectPrompts.randomElement()!
                    selected = "🔮"
                }
                if promptSelectedIndex == 3 {
                    dynamicPrompt = "Let it all out, don't hold back."
                    selected = "💢"
                }
                if promptSelectedIndex == 4 {
                    dynamicPrompt = settings.gratitudePrompts.randomElement()!
                    selected = "🙏🏾"
                }
            }
            .onChange(of: message) { value in
                if (message != "") {
                    dateString = dateFormatter.string(from: date as Date)
                }
            }
            .onTapGesture {
                hideKeyboard() //hide keyboard when user taps outside text field
//                    .onAppear() {
//                    }
            }
            .onAppear() {
                message = note.note
                selected = note.emoji ?? ""
                dynamicPrompt = note.prompt ?? ""
                
//                if (note.prompt != "" || note.prompt != nil) {
//                    defaultPrompt.prompt = note.prompt ?? selectedPrompt.prompt
//                } else {
//                    defaultPrompt.prompt = selectedPrompt.prompt
//                }
            }
            .onDisappear() {
                print(note.note ?? "none")
                promptSelectedIndex = 0
                if promptSelectedIndex != 1 {
                    
                    //remove all notifications with the same message if note to self
                    clearNotifications(message: message ?? "")
                    
                }
                
                if ((message != "" || selected != "") && message !=
                        settings.welcomeText && (message != initialText || selected != initialEmoji)) {
                    saveNoteB()
                    
                }
                promptSelectedIndex = 0
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
//            initialText = note.note ?? ""
            dateFormatter.dateFormat = "MMM dd, yyyy | h:mm a"
            dateString = dateFormatter.string(from: date as Date)
            
        }
        .padding(.top, 60)
        .background(Color(UIColor(named: "NoteBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
    
    func saveNoteB () {
            note.id = UUID() //create id
            
            if promptSelectedIndex == 3 {

                note.note = message ?? ""

                note.emoji = (selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") ? selected : selectedPrompt.emoji  // emoji
                note.prompt = selectedPrompt.prompt

                print("aaa")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    note.note = "Message autodeleted" //input message
                    note.emoji = "🗑"  // emoji
                    note.prompt = ""
                    try? self.moc.save()
                    print("a")
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    note.note = "..." //input message
                    note.emoji = ""  // emoji
                    note.prompt = ""
                    try? self.moc.save()
                }

            } else {
                note.note = message ?? "" //input message
            }
            
            note.date = dateString //formatted date to display
        
            note.emoji = ((selectedPrompt.emoji == "" || selectedPrompt.emoji == "X" || selectedPrompt.emoji == "🗒️") ? selected : selectedPrompt.emoji)
        
//        print(note.prompt ?? "")
//            note.prompt = selectedPrompt.prompt
        
//            print(note.prompt ?? "")
        
        note.prompt = dynamicPrompt
            
            if (promptSelectedIndex == 1) {
                note.helpText = "Note will be sent back to you"
            }
            if (promptSelectedIndex == 3) {
                note.helpText = "Note will be autodeleted"
            }
        
            try? self.moc.save()
        
    }
    
    func clearNotifications (message: String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
            if notification.identifier == "Note to Self \(message)" {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
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

struct promptContent: View {
    
    @Binding var promptSelectedIndex: Int
    @ObservedObject var settings: SettingsModel
    @Binding var dynamicPrompt:  String
    @Binding var message: String
    @Binding var selectedPrompt: Prompt
    
    @State var noteToSelfNotification = Date()
    @State var noteToSelfRandomTime = false
    
    var body: some View {
        //show prompt
        if (promptSelectedIndex != 0) {
            if promptSelectedIndex == 4 {
                Text("\(dynamicPrompt)")
                    .font(Font.custom("Poppins-Medium", size: 16))
                    .padding(.top, 10)
                    .padding(.bottom, -8)
                    .onAppear() {
                        dynamicPrompt = settings.gratitudePrompts.randomElement()!
                    }
            } else if promptSelectedIndex == 2 {
                Text("\(dynamicPrompt)")
                    .font(Font.custom("Poppins-Medium", size: 16))
                    .padding(.top, 10)
                    .padding(.bottom, -8)
                    .onAppear() {
                        dynamicPrompt = settings.introspectPrompts.randomElement()!
                    }
            } else {
                Text("\(selectedPrompt.prompt)")
                    .font(Font.custom("Poppins-Medium", size: 16))
                    .padding(.top, 10)
                    .padding(.bottom, -8)
            }
        }
                
        //if vent selected
        if promptSelectedIndex == 3 {
            HStack {
                Image(systemName: "trash")
                
                Text("This will be autodeleted")
                    
            }
            .foregroundColor(Color.red)
            .font(Font.custom("Poppins-Regular", size: 16))
            .padding(.top, 8)
        }
        
        //if note to self selected, show note to self notification options
        if (promptSelectedIndex == 1) {
            HStack {
                Image(systemName: "paperplane")
                
                Text("This will be sent back to you")
                    
            }
            .foregroundColor(Color.blue)
            .font(Font.custom("Poppins-Regular", size: 16))
            .padding(.vertical,5)
            
            VStack {
                
                Picker(selection: $noteToSelfRandomTime, label: Text("Random or manual time?")) {
                    Text("Random Time").tag(false)
                    Text("Manual Time").tag(true)
                }
                .font(Font.custom("Poppins-Regular", size: 16))
                .pickerStyle(SegmentedPickerStyle())
                
                if noteToSelfRandomTime {
                    DatePicker(
                        "",
                        selection: $noteToSelfNotification,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .onChange (of: noteToSelfNotification) { value in
                        if message != "" {
                            createNotification(message: message, dateIn: noteToSelfNotification)
                        }
                    }
                } else {
                    Text("This note will return to you sometime in the next week")
                        .font(Font.custom("Poppins-Regular", size: 0)).opacity(0)
                        .padding(.bottom, -22)
                        .onAppear() {
                            if message != "" {
                                createNotification(message: message, dateIn: generateRandomDate(daysForward: 7)!)
                            }
                        }
                        .onChange (of: message) { value in
                            if message != "" {
                                createNotification(message: message, dateIn: generateRandomDate(daysForward: 7)!)
                            }
                        }
                        
                }
            }
        }
    }
    
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
