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
    
    @State var noteToSelfNotification = Date()
    @State var noteToSelfRandomTime = false
    
    @State private var emojiPickerShowing: Bool = false;
    @State private var addPromptShowing: Bool = false;

    @State var initialText =  ""
    @State var initialEmoji = ""

    let note: Note  // = Note(context: self.moc)

    @Binding var promptSelectedIndex: Int
    @Binding var tabIndex: Int
    @Binding var showPageSlider: Bool
    
    @State var dynamicPrompt = ""
    
    var body: some View {
        
        ZStack {
            VStack {
                NoteTopMenuView(settings: settings, tabIndex: $tabIndex)
                
                HStack {
                    Text("\(dateString)")
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3037465077)))
                    
                }
                .padding(.bottom, 20)
                .onAppear() {
                    dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
                    if note.date != "-" {
                        dateString = dateFormatter.string(from: (note.createdAt ?? date) as Date)
                    } else {
                        dateString = note.date ?? "-"
                    }
                }
//
//            Divider()
//                .foregroundColor(Color.primary)
//                .padding(.horizontal, 20)
//                .padding(.bottom, 3)
            
            //text input
            VStack {
                ScrollView {
                    
                    // body content
                    VStack (alignment: .leading) {
                        
                        
                        Text(selected)
                            .font(Font.custom("Poppins-Regular", size: 48))
                            .padding(.bottom, 3)
                        
                        if dynamicPrompt != "" {
                            Text(dynamicPrompt)
                                .font(Font.custom("Poppins-Bold", size: 16))
//                                .padding(.top, 16)
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
                        
                        //text input
                        GrowingTextInputView(text: $message, placeholder: "Tap here to begin typing")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .padding(.leading, -4)
                            .padding(.top, -5)
                        
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
            }
            .onAppear() {
                message = note.note
                selected = note.emoji ?? ""
                dynamicPrompt = note.prompt ?? ""
            }
            .onDisappear() {
                
                
                if promptSelectedIndex != 1 {
                    
                    //remove all notifications with the same message if note to self
                    clearNotifications(message: message ?? "")
                    
                }
                
//                if promptSelectedIndex == 3 {
////                    
////                    note.note = message ?? ""
////                    note.emoji = "💢"
////                    note.prompt = dynamicPrompt
//
//                    print("aaa")
//                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                        note.note = "Message autodeleted" //input message
//                        note.emoji = "🗑"  // emoji
//                        note.prompt = ""
//                        try? self.moc.save()
//                    }
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                        note.note = "" //input message
//                        note.emoji = ""  // emoji
//                        note.prompt = ""
//                        try? self.moc.save()
//                        print("note deleted")
//                    }
//                }
                
                
                if ((message != "" || selected != "") && message !=
                        settings.welcomeText && (message != initialText || selected != initialEmoji)) {
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
                
                if (promptSelectedIndex == 0) {
                    EmojiButton(emojiPickerShowing: $emojiPickerShowing)
                }
                
                
                SwiftSpeechButtonView(output: $swiftSpeechTempText)
                    .onChange (of: swiftSpeechTempText) { value in
                        message = swiftSpeechTempText
                    }
                    .animation(.easeOut)

                PromptsButton(addPromptShowing: $addPromptShowing)
                
                
                Spacer()
                
                Button (action: { showPageSlider.toggle() }) {
                    Text("🗂")
                        .font(.system(size: 30))
                }
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
        .padding(.top, 10)
        .background(Color(UIColor(named: "NoteBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
    
    func saveNoteB () {
        
        note.id = UUID() //create id
    
        note.note = message ?? "" //input message
        
        note.date = dateString //formatted date to display
    
        note.emoji = selected
        
        note.prompt = dynamicPrompt
        
        try? self.moc.save()
        
        promptSelectedIndex = 0
        
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
