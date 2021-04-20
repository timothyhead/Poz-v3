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
    @Binding var promptSelectedFromHome: Bool
    @Binding var tabIndex: Int
    @Binding var showPageSlider: Bool
    
    @State var dynamicPrompt = ""
    
    @State var confirmDelete = false
    
    @State var newText = ""
    
    @State var isLastPage = false
    
    @Binding var pageIndex: Int
    
    var body: some View {
        
        VStack {
//            VStack {
                NoteTopMenuView(settings: settings, tabIndex: $tabIndex)
                
                HStack {
                    Text("\(dateString)")
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3037465077)))
                    
                }
                .padding(.bottom, 20)
                .onChange(of: message) { value in
                    if (message != "" && message != initialText && dateString != dateFormatter.string(from: Date() as Date)) {
                        dateString = dateFormatter.string(from: Date() as Date)
                    }
                }
            
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
                                .font(Font.custom("Poppins-Medium", size: 16))
                        }
                        
                        if promptSelectedIndex == 0 {
                        }
                        if selected == "📪" {
                            if message != initialText {
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
                        }
                        if selected == "💢" {
//                            if message != initialText {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("This will be autodeleted")

                                }
                                .foregroundColor(Color.red)
                                .font(Font.custom("Poppins-Regular", size: 16))
                                .padding(.top, 8)
//                            }
                        }
                        
                        //text input
                        GrowingTextInputView(text: $message, placeholder:
                            """
                            Tap to begin typing

                            Shake for a prompt ⚡️
                            """)
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .padding(.leading, -4)
                            .padding(.top, -5)
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 50)
                }
                
                .padding(.top, -11)
            }
//            .onChange(of: promptSelectedIndex) { value in
//                if promptSelectedIndex == 0 {
//                    dynamicPrompt = ""
//                    selected = ""
//                }
//                if promptSelectedIndex == 1 {
//                    dynamicPrompt = "Leave a note or reminder for your future self."
//                    selected = "📪"
//                }
//                if promptSelectedIndex == 2 {
//                    dynamicPrompt = settings.introspectPrompts.randomElement()!
//                    selected = "🔮"
//                }
//                if promptSelectedIndex == 3 {
//                    dynamicPrompt = "Let it all out, don't hold back."
//                    selected = "💢"
//                }
//                if promptSelectedIndex == 4 {
//                    dynamicPrompt = settings.gratitudePrompts.randomElement()!
//                    selected = "🙏🏾"
//                }
//            }
            .onTapGesture {
                hideKeyboard() //hide keyboard when user taps outside text field
            }
            .onAppear() {
                initialText = note.note ?? ""
                message = note.note
                selected = note.emoji ?? ""
            
                
//                print(dynamicPrompt)
//                print(note.prompt ?? "")
                dynamicPrompt = note.prompt ?? ""

                
                dateFormatter.dateFormat = "MMM dd, yyyy | h:mm a"
                
                if (dateFormatter.string(from: (note.lastUpdated ?? date) as Date) != "Dec 31, 2000 | 4:00 PM") {
                    dateString = dateFormatter.string(from: (note.lastUpdated ?? date) as Date)
                } else {
                    dateString = "-"
                }
                
                if note.note == "" && message == "" && note.emoji == "" && note.prompt == "" {
                    dateString = dateFormatter.string(from: Date() as Date)
                }
            }
            .onDisappear() {
                
                
                if promptSelectedIndex != 1 {
                    //remove all notifications with the same message if note to self
                    clearNotifications(message: message ?? "")
                }
                
                
                if ((message != "" || selected != "") && message !=
                        settings.welcomeText && (message != initialText || selected != initialEmoji)) {
                    saveNoteB()
                }
                
            }
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                dynamicPrompt = settings.allPrompts.randomElement()!
            }

            if emojiPickerShowing {
                EmojiPicker(selectedIndex: $selectedIndex, selected: $selected)
//                    .padding(.bottom, 20)
            }
                
//            if addPromptShowing {
//                PromptsViewC(promptIndex: $promptSelectedIndex)
//                    .padding(.bottom, 50)
//            }
            
            HStack (spacing: 0) {
                
                if (promptSelectedIndex == 0) {
                    EmojiButton(emojiPickerShowing: $emojiPickerShowing)
                }
                
                
                SwiftSpeechButtonView(input: $swiftSpeechTempText, output: $swiftSpeechTempText)
                    .onChange (of: swiftSpeechTempText) { value in
                        message = swiftSpeechTempText
                    }
                    .onAppear() {
                        swiftSpeechTempText = message ?? ""
                    }
//                    .animation(.easeOut)

                
                // basic prompt button
                Button (action: {
                    dynamicPrompt = settings.allPrompts.randomElement()!
                }) {
                    Text("⚡️")
                        .font(.system(size: 25))
                }
                .padding(.trailing, 20)
                
                //advanced prompt button
//                PromptsButton(addPromptShowing: $addPromptShowing)
                
                Button (action: {
                    //clearNote()
                    confirmDelete = true
                }) {
                    Text("🗑️")
                        .font(.system(size: 25))
                }
                .alert(isPresented: $confirmDelete) {
                    Alert(
                        title: Text("Are you sure you want to delete this note?"),
                        message: Text("This will remove this page from the notebook. You cannot undo this"),
                        primaryButton: .destructive(Text("Delete note")) {
                            print("Deleting...")
                            clearNote()
                        },
                        secondaryButton: .cancel()
                    )
                }
//                .animation(.easeOut)
//                .padding(.horizontal, 20)
                
                Spacer()
                
                if (!showPageSlider) {
                    Text("\(getPageNumber())")
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(UIColor(named: "PozGray")!))
                }
                
                Spacer()
                
                Button (action: {
                    withAnimation(.easeOut) {
                        showPageSlider.toggle()
                    }
                }) {
                    Text(showPageSlider ? "📖" : "📔")
                        .font(.system(size: 30))
                }
            }
            .padding(.bottom, 40)
            .padding(.horizontal, 20)
                
            }
//        }
        .padding(.top, 10)
        .background(Color(UIColor(named: "NoteBG")!)) // isLastPage ? Color(UIColor(named: "PozYellow")!) : 
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
    
    func getPageNumber() -> Int {
        
        var noteCount = 0
        
        for noteObj in notes {
            noteCount += 1
            if note.id == noteObj.id {
                break
            }
        }
        return (noteCount)
    }
    
    func isCurrNoteLastPage () -> Bool {
           
        if (pageIndex == (notes.count-2)) {
            print("true")
            return true
            
        } else {
            print(pageIndex)
            print(notes.count)
            return false
        }
    }
    
    func activatePrompt() {
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
//        promptSelectedFromHome = false
    }
    
    func saveNoteB () {
        
//        if (promptSelectedIndex == 3) {
//            note.note = ""
//            note.prompt = ""
//            note.emoji = ""
//        } else {
//
            note.id = UUID() //create id
            note.note = message ?? "" //input message
            note.lastUpdated = Date()
            dateFormatter.dateFormat = "MMM dd, yyyy | h:mm a"
            note.date = dateFormatter.string(from: (note.lastUpdated ?? Date()) as Date)
            note.emoji = selected
            note.prompt = dynamicPrompt
//        }
        
        try? self.moc.save()
        
        promptSelectedIndex = 0
//        promptSelectedFromHome = false
        
    }
    
    func clearNote() {
        message = ""
        note.note = ""
        selected = ""
        note.emoji = ""
        note.prompt = ""
        dateString = "-"
        note.date = "-"
        note.createdAt = Date()
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
//            if emojiPickerShowing {
//                Text("Tag with emoji")
//                    .font(Font.custom("Poppins-Light", size: 16))
//                    .zIndex(-1)
//                    .offset(x: 0, y: -35)
//
//            }
            Button(action: {
                withAnimation() {
                    emojiPickerShowing.toggle()
                }
            }) {
                Text("🎭")
                    .font(.system(size: 30))
            }
        }
//        .animation(.easeOut)
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
                
                Text("⚡️")
                    .font(.system(size: 30))
            }
        }
        .scaleEffect((addPromptShowing ? 1.76 : 1))
//        .animation(.easeOut)
    }
}

extension NSNotification.Name {
    public static let deviceDidShakeNotification = NSNotification.Name("MyDeviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
}

