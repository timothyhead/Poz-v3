import SwiftUI
import EventKit

// a page of a note

struct NotePage: View {
    
    // gets all notes from core data
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TempNoteData.messageId,ascending: true)]) var tempData: FetchedResults<TempNoteData>
    @ObservedObject var settings: SettingsModel
    
    // color scheme
    @Environment(\.colorScheme) var colorScheme
    
    // temp vars to hold note data
    @State private var message: String?
    @State private var emoji: String = ""
    
    // for swift speech
    @State private var noteSelfTempText: String = ""
    @State private var swiftSpeechTempText: String = ""

    // for emoji
    @State var selected = ""
    @State private var selectedIndex: Int = 0
    
    // for date
    @State var date = Date()
    @State var dateFormatter = DateFormatter()
    @State var dateString: String = ""
    
    // for complex prompts, not in use
    @State var noteToSelfNotification = Date()
    @State var noteToSelfRandomTime = false
    
    // for showing the specific popups
    @State private var emojiPickerShowing: Bool = false;
    @State private var addPromptShowing: Bool = false;

    // for checking whether use has modifies previously entered note
    @State var initialText =  ""
    @State var initialEmoji = ""

    // passes in note object from notebook view - *important*
    let note: Note  // = Note(context: self.moc)

    // for controlling prompt and updating note page
    @Binding var promptSelectedIndex: Int
    @Binding var promptSelectedFromHome: Bool
    
    // for navigation
    @Binding var tabIndex: Int
    @Binding var showPageSlider: Bool
    
    // prompt that changes when user shakes or selects
    @State var dynamicPrompt = ""
    
    // for deleting
    @State var confirmDelete = false
    
    // page in notebook
    @Binding var pageIndex: Int
    
    @State var saveNotesToCal = UserDefaults.standard.bool(forKey: "saveToCal")
    
    @State private var k: Constants = Constants.shared
    // the value of the textView in the text input view
    @State private var focused: Bool = false
    
    //sheet in toolbar for search bar
    @State var prevPostsShowing = false
    
    let eventStore = EKEventStore()
    
    var body: some View {
        
        VStack {
//            VStack {
            // now using toolbar
            // top menu, back button, search button
            //    NoteTopMenuView(settings: settings, tabIndex: $tabIndex)
                
                HStack {
                    Text("\(dateString)")
                        .font(Font.custom("Poppins-Regular", size: 14))
                        .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3037465077)))
                    
                }
        }
    
                .padding(.bottom, 20)
                .onChange(of: message) { value in
                    if (message != "" && message != initialText && dateString != dateFormatter.string(from: Date() as Date)) {
                        dateString = dateFormatter.string(from: Date() as Date)
                    }
                }
            
           
            
            VStack {
                ScrollView {
                    
                    // body content
                    VStack (alignment: .leading) {
                        
                        // emoji
                        Text(selected)
                            .font(Font.custom("Poppins-Regular", size: 48))
                            .padding(.bottom, 3)
                        
                        // prompt, only shows if not empty
                        if dynamicPrompt != "" {
                            Text(dynamicPrompt)
                                .font(Font.custom("Poppins-Medium", size: 16))
                        }
                        
                        // prompt stuff
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
                        //MARK: - TEXT INPUT
                        //text input
                        GrowingTextInputView(text: $message,placeholder:
                        """
                        Tap to begin typing
                        
                        Shake for a prompt ⚡️
                        """, focused: $focused)
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .padding(.leading, -4)
                        .padding(.top, -5)
                        
                    }
                    .padding(.horizontal, 20)
                    //MARK: - onchange focused
                    .onChange(of: focused) { _ in
                        if focused == false
                            && (((message != "" || selected != "") && message !=
                                 settings.welcomeText && (message != initialText || selected != initialEmoji))) {
                            hideKeyboard()
                            moc.perform {
                                
                                //                        newMessage = text
                                if let currentMessage = tempData.first(where:   { $0.messageId == k.messageId }) {
                                    currentMessage.tempMessage = message ?? ""
                                    currentMessage.noteId = note.id?.uuidString
                                    dateFormatter.dateFormat = "MMM dd, yyyy | h:mm a"
                                    currentMessage.date = dateFormatter.string(from: (note.lastUpdated ?? Date()) as Date)
                                    currentMessage.emoji = selected
                                    currentMessage.prompt = dynamicPrompt
                            
                                    try? moc.save()
                                 
                                    print("tempMessage saved")
                                }
                               
                            }
                            
                        }
                        
                        
                    }
                    
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
                
                // initialize note
                
                initialText = note.note ?? ""
                initialEmoji = note.emoji ?? ""
                message = note.note
                selected = note.emoji ?? ""

                dynamicPrompt = note.prompt ?? ""

                dateFormatter.dateFormat = "MMM dd, yyyy | h:mm a"
                
                // initializes date
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
                
                // remove notifications for specific prompts, noto in use
                if promptSelectedIndex != 1 {
                    //remove all notifications with the same message if note to self
                    clearNotifications(message: message ?? "")
                }
                
                // saves note
                if ((message != "" || selected != "") && message !=
                        settings.welcomeText && (message != initialText || selected != initialEmoji)) {
//                    print (message)
//                    print (updatedText)
//                    print(selected)
//                    print(initialText)
//                    print(initialEmoji)
//                    print ("something's changed")
                    saveNoteB()
                }
                
            }
            // check if user shakes device
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                // change prompt
                dynamicPrompt = settings.allPrompts.randomElement()!
            }

            // emoji pickers
            if emojiPickerShowing {
                EmojiPicker(selectedIndex: $selectedIndex, selected: $selected)
//                    .padding(.bottom, 20)
            }
                
            // prompt picker
//            if addPromptShowing {
//                PromptsViewC(promptIndex: $promptSelectedIndex)
//                    .padding(.bottom, 50)
//            }
            
            // bottom menu
            HStack (spacing: 0) {
                
                //emoji button
                if (promptSelectedIndex == 0) {
                    EmojiButton(emojiPickerShowing: $emojiPickerShowing)
                }
                
                // speech to text button
                SwiftSpeechButtonView(input: $swiftSpeechTempText, output: $swiftSpeechTempText)
                    .onChange (of: swiftSpeechTempText) { value in
                        if let _ = message {
                            message! += " " + swiftSpeechTempText + " "
                        }
                    }
                    .onAppear() {
                        swiftSpeechTempText = message ?? ""
                    }
//                    .animation(.easeOut)

                
                // basic prompt button
                Button (action: {
//                    dynamicPrompt = settings.allPrompts.randomElement()!
                }) {
                    Text("⚡️")
                        .font(.system(size: 25))
                        .onTapGesture {
                            dynamicPrompt = settings.allPrompts.randomElement()!
                        }
                        .onLongPressGesture(minimumDuration: 0.1) {
                            dynamicPrompt = ""
                        }
                }
                .padding(.trailing, 20)
                
                
                //advanced prompt button
//                PromptsButton(addPromptShowing: $addPromptShowing)
                
                // delete button
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
                

//        }
        .padding(.top, 10)
        .background(Color(UIColor(named: "NoteBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
    
    // get page number of current note
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
    
    // checks if curr note is the last page, not in use
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
    
    // for prompts, not in use
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
        // not now used - note saved in parentview except for saving note to calender
    // saves note
    func saveNoteB () {
        
//        if (promptSelectedIndex == 3) {
//            note.note = ""
//            note.prompt = ""
//            note.emoji = ""
//        } else {
//
//            note.id = UUID() //create id
//            note.note = message ?? "" //input message
//            note.lastUpdated = Date()
//            dateFormatter.dateFormat = "MMM dd, yyyy | h:mm a"
//            note.date = dateFormatter.string(from: (note.lastUpdated ?? Date()) as Date)
//            note.emoji = selected
//            note.prompt = dynamicPrompt
////        }
//        
//        try? self.moc.save()
        
        promptSelectedIndex = 0
//        promptSelectedFromHome = false
        
        
        if (saveNotesToCal) {
            //write note to calendar
            let calDateFormatter = DateFormatter()
            calDateFormatter.dateFormat = "yyyyddHHmmSSS"
            
            var titleForCal = ""
            if (selected == "") {
                titleForCal = "📔 Poz Entry"
            } else {
                titleForCal = selected + " Poz Entry";
            }
            
            var messageForCal = message ?? "\n"
            messageForCal += "\n\nLast Updated on "
            messageForCal += dateFormatter.string(from: (note.lastUpdated ?? Date()) as Date)
            messageForCal += "\n\nPoz Entry ID: " + calDateFormatter.string(from: (note.createdAt ?? Date()) as Date)
            
            CalendarController().askToAddToCal(start: note.lastUpdated ?? Date(), end: note.lastUpdated ?? Date(), id: calDateFormatter.string(from: (note.createdAt ?? Date()) as Date), title: titleForCal, notes: messageForCal)
        }
        
    }
    
    // clears note and moves it to end
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
    
    // clears all notifications with certain string
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
    
    // creates notification
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
    
    // for one of the prompts, not in use
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

// not in use
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
            Button(action: {
//                addPromptShowing.toggle()
            }) {
                Text("⚡️")
                    .font(.system(size: 30))
                    .onTapGesture {
                        addPromptShowing.toggle()
                        print("short press")
                    }
                    .onLongPressGesture(minimumDuration: 0.1) {
                        addPromptShowing.toggle()
                        print("long press")
                    }
            }
        }
        .scaleEffect((addPromptShowing ? 1.76 : 1))
//        .animation(.easeOut)
    }
}


// detects device shake
extension NSNotification.Name {
    public static let deviceDidShakeNotification = NSNotification.Name("MyDeviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
    }
}
