import SwiftUI
import LocalPackage

// notebook that displays all journal entries in page turn style
// using pages library by https://github.com/nachonavarro/Pages

struct NotebookView: View {
    
    
    
    
    // settings, color scheme
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt,ascending: true)] // notes sorted from first created to last
    ) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TempNoteData.messageId,ascending: true)]) var tempData: FetchedResults<TempNoteData>
    
    // main nav var
    @Binding var tabIndex: Int
    
    // for prompts, not in use
    @Binding var promptSelectedIndex: Int
    @Binding var promptSelectedFromHome: Bool
    
    // get the last page that was open from user defaults
//
//    @State var indexNotes: Int = UserDefaults.standard.integer(forKey: "LastPageOpen")
    // for onboarding
    @State var firstTimeShowing = true
    
    //for page slider
    @State var showPageSlider = false
    @State var isEditing = true
    
    // for last page detection, not in use
    @State var isLastPage = false
    // for updating notes
    @State private var k: Constants = Constants.shared
    @State private var defaults = UserDefaults.standard
    //sheet in toolbar for search bar
    @State var prevPostsShowing = false
    // for putting the date value in notes into a string format
    @State var dateFormatter = DateFormatter()
    // for bottom bar
    @State private var emojiPickerShowing: Bool = false;
    // for swift speech
    @State private var noteSelfTempText: String = ""
    @State private var swiftSpeechTempText: String = ""
    // temp vars to hold note data
    // @State private var message: String?
    @State private var emoji: String = ""
    // prompt that changes when user shakes or selects
    @State var dynamicPrompt = ""
    // for deleting
    @State var confirmDelete = false
    @State private var savedNoteId: String = ""
    // for page number - to avoid repeated renders of view
    @State private var pageIndex: Int = 0
    private var pageNumber: Int {
        
        pageIndex + 1
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                
                //            NoteTopMenuView(settings: settings, tabIndex: $tabIndex)
                
                // dynamic page system of all note objects in array of core data
                // MARK: - ModelPages
                ModelPages (
                    
                    notes, currentPage: $pageIndex,
                    transitionStyle: .pageCurl,
                    bounce: true,
                    hasControl: false
                    
                ) { pageIndex, note in
                    
                    // note page, passing in almost everything possible
                    NotePage(settings: settings, note: note, promptSelectedIndex: $promptSelectedIndex, promptSelectedFromHome: $promptSelectedFromHome, tabIndex: $tabIndex, showPageSlider: $showPageSlider, dynamicPrompt: $dynamicPrompt).environment(\.managedObjectContext, self.moc)
                        .onDisappear () {
                            // when notebook closes, save last open page
                            defaults.set(pageIndex, forKey: "LastPageOpen")
                            // get the note to be updated
                            moc.perform {
                                tempData.first(where: { $0.messageId == k.messageId } )?.noteId = note.id?.uuidString ?? ""
                                try? moc.save()
                            }
                        }
                }
                
                .padding(.top, -6)
                // MARK: - onChange defaults.bool(forKey: k.pageTurned)
                //  make new note on the page that has been turned away from when the page is turned. ie. not the new page but the last one.
                .onChange(of: defaults.bool(forKey: k.pageTurned) ) { _ in
                    // with a new page turn thePageNumber property increases above the defaults.integer(forKey: k.lastIndex) value
                    Task {
                        savedNoteId = ""
                        savedNoteId =  await saveNote()
                

                        
                    }
                 
                }
                //MARK: -  .onChange(of: savedNoteId)
                .onChange(of: savedNoteId) { newValue in
                    if savedNoteId.isEmpty { return }
                    //o=make a new note only if it's the last, but two notes -  so the PageModel has a blank note to turn to.
                    makeNoteConditionalyOnForwardTurn()
                }
                
                // MARK: - page turn slider
                if showPageSlider {
                    
                    ZStack {
                        
                        if (isEditing || showPageSlider) {
                            Text("\(pageNumber) \(notes.count)")
                                .font(Font.custom("Poppins-Regular", size: 16))
                                .offset(x: 74, y: 41)
                        }
                        // slider uses a binding extension to use the pageIndex as an Integer
                        Slider(
                            value: .convert($pageIndex),
                            in: 0...Double(notes.count - 2),
                            onEditingChanged: { editing in
                                isEditing = editing
                                if !isEditing {
                                    showPageSlider = false
                                }
                            }
                        )
                    }
                    .onAppear() {
                      
                    }
                    .background(Color(UIColor(named: "NoteBG")!))
                    .offset(y: (UIScreen.main.bounds.height/2 - 100))
                    .padding()
                    
                }
                
                // onboarding
                if (firstTimeShowing) {
                    SwipeTutorialView(show: firstTimeShowing)
                        .onAppear() {
                            firstTimeShowing = firstTimeAppearing()
                        }
                }
            }
     
            // MARK: - onAppear
            .onAppear() {
                print("onappear in notebook")
                // initialize notebook page to last opened page
                if promptSelectedIndex != 0 {
                    defaults.set(findFirstEmptyPage(), forKey: "LastPageOpen")
                }
                tempData.first(where:  { $0.messageId == k.messageId })?.tempMessage = ""
                //. tempData.first(where:  { $0.messageId == k.messageId })?.noteId = ""
                tempData.first(where:  { $0.messageId == k.messageId })?.emoji = ""
                pageIndex = defaults.integer(forKey: "LastPageOpen")
            }
            .onTapGesture {
                
                // close onboarding on click
                firstTimeShowing = false
            }
            
            // MARK: - tool bar
            // for top and bottom of view. I can't place i ti the prefered NotePageView as buttons don't fire!
            .toolbar {
                                ToolbarItem(placement: .bottomBar) {
                                    //emoji button
                                    if (promptSelectedIndex == 0) {
                                        EmojiButton(emojiPickerShowing: $emojiPickerShowing)
                                    }
                
                                }
                ToolbarItem(placement: .bottomBar) {
                    ////                    // speech to text button
                    SwiftSpeechButtonView(input: $swiftSpeechTempText, output: $swiftSpeechTempText)
                        .onChange (of: swiftSpeechTempText) { value in
                            if let data = tempData.first(where:  { $0.messageId == k.messageId }) {
                                var message = data.tempMessage ?? ""
                                print("onchange \(message)")
                                print(swiftSpeechTempText, " swiftSpeechTempText")
                                message += " " + value + " "
                                notes.first(where:  { $0.id?.uuidString == data.noteId } )?.note! += message
                                try? moc.save()
                                
                            }
                            
                            
                        }
//                        .onAppear() {
//                            if let data = tempData.first(where:  { $0.messageId == k.messageId }) {
//                                swiftSpeechTempText = notes.first(where:  { $0.id?.uuidString == data.noteId } )?.note ?? ""
//                            }
//                        }
                }
                ToolbarItem(placement: .bottomBar) {
                    // MARK: - bottom bar
                    // basic prompt button
                    Button (action: {
                        dynamicPrompt = settings.allPrompts.randomElement()!
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
                }
                ToolbarItem(placement: .bottomBar) {
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
                    //                //                .padding(.horizontal, 20)
                }
                ToolbarItem(placement: .bottomBar) {
                    if (!showPageSlider) {
                        Text("\(pageNumber)")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .foregroundColor(Color(UIColor(named: "PozGray")!))
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button (action: {
                        withAnimation(.easeOut) {
                            showPageSlider.toggle()
                        }
                    }) {
                        Text(showPageSlider ? "📖" : "📔")
                            .font(.system(size: 30))
                    }
                    
                }
                // MARK: - top bar
                ToolbarItem(placement: .topBarLeading) {
                    
                    if notes.count > 2 {
                        Button (action:{ prevPostsShowing.toggle() }) {
                            
                            Text("🔍")
                            //                        Image(systemName: "clock.arrow.circlepath")
                                .font(Font.custom("Poppins-Light", size: 20))
                                .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.9333333333, alpha: 1)) : Color(#colorLiteral(red: 0.1514667571, green: 0.158391118, blue: 0.1616251171, alpha: 1)))
                        }.frame(width: 40, height: 40)
                    }
                    
                    
                }
                ToolbarItem(placement: .topBarTrailing) {
                    
                    // home button
                    Button (action: {
                        
                        withAnimation(.spring()) {
                            
                            exit()
                        }
                        
                    }) {
                        ZStack {
                            
                            if colorScheme == .dark {
                                Text("✖️")
                                    .font(Font.custom("Poppins-Light", size: 26))
                                    .colorInvert()
                            } else {
                                Text("✖️")
                                    .font(Font.custom("Poppins-Light", size: 26))
                            }
                            
                        }
                        .frame(width: 40, height: 40)
                    }
                }
                
            }
            .background(Color("NoteBG"))
            
            // MARK: - sheet prevPostsShowing
            .sheet(isPresented: $prevPostsShowing, content: {
                NotesListView(settings: settings).environment(\.managedObjectContext, self.moc)
            })
        }
    }
    
    // check if first time screen appearing for onboarding
    func firstTimeAppearing()->Bool{
        let homeScreendefaults = UserDefaults.standard
        
        if let firstTimeAppearing = homeScreendefaults.string(forKey: "firstTimeNotebookAppearing"){
            
            print("Screen already launched : \(firstTimeAppearing)")
            return false
            
        } else {
            
            homeScreendefaults.set(true, forKey: "firstTimeNotebookAppearing")
            print("Screen launched first time")
            return true
            
        }
    }
    
    ///        // makes a new note so the Modelpages has a page to turn only if the note is the last but two and it's a forward turn
    func makeNoteConditionalyOnForwardTurn() {
      
        if pageNumber > defaults.integer(forKey: k.lastIndex) && notes.count - 1 == pageIndex {
            print("new note made")
            let note = Note(context: moc)
            note.id = UUID()
            note.note = ""
            note.createdAt = Date()
            note.lastUpdated = Date()
            try? moc.save()
            
        }
        // sets the page of the current index so with a new page turn the if statement above can use it as the previous index
        defaults.set(pageNumber, forKey: k.lastIndex)
    }
    
    // finds the first empty page
    func findFirstEmptyPage () -> Int {
        var noteIndex = 0
        
        for note in notes {
            noteIndex += 1
            
            if note.note == "" && note.emoji == "" {
                break
            }
        }
        return noteIndex - 1
    }
    // MARK: - saveNote()
    /// /// Saves the updated or new created note using the tempData
    /// - Returns: the note id from the currnent note being updated or created
    func saveNote() async -> String {
        
        // The message and data from within the ModelPages struct in the tempData core data object
        let message = tempData.first(where:  { $0.messageId == k.messageId } )?.tempMessage ?? "no message"
        let emoji = tempData.first(where:  { $0.messageId == k.messageId } )?.emoji ?? "no message"
        let noteId =  tempData.first(where:  { $0.messageId == k.messageId} )?.noteId
        let prompt = tempData.first(where:  { $0.messageId == k.messageId } )?.prompt
        print(message, " message in saveNote")
        guard ((message != "" || emoji != "") && message !=
               settings.welcomeText) else {
            print("returning from guard in saveNote(): message or emoji is empty")
            return ""
        }
        
        // update the note that was added to or add the new message and data on the new note  which was created in the block below in this onchange f: defaults.bool(forKey: k.pageTurned
        notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.note = message
        notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.emoji = emoji
        notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.prompt = prompt
        notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.lastUpdated = Date()
        dateFormatter.dateFormat = "MMM dd, yyyy | h:mm a"
        notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.date = dateFormatter.string(from: (Date()))
        
        try? moc.save()
        // save noteId in property - noteId deleted before return
        let returnValueId = noteId
        // tempData removed to the current note being over written with a unwanted call to this function in onChange defaults.bool(forKey: k.pageTurned), when a page is turned
        tempData.first(where:  { $0.messageId == k.messageId })?.tempMessage = ""
        tempData.first(where:  { $0.messageId == k.messageId })?.noteId = ""
        tempData.first(where:  { $0.messageId == k.messageId })?.emoji = ""
        try? moc.save()
        return returnValueId ?? ""
    }
    // clears note and moves it to end
    func clearNote() {
        if let note = notes.first(where:  { $0.id?.uuidString == tempData.first(where:  { $0.messageId == k.messageId })?.noteId }) {
            
            note.note = ""
            note.emoji = ""
            note.prompt = ""
            note.date = "-"
            note.createdAt = Date()
        }
    }
    // get page number of current note
    // not needed
    func getPageNumber() -> Int {
        
        var noteCount = 0
        
        for noteObj in notes {
            noteCount += 1
            if tempData.first(where:  { $0.messageId == k.messageId })?.noteId == noteObj.id?.uuidString  {
                break
            }
        }
        return (noteCount)
        // return 1
    }
    func exit() {
        
        Task {
            _ = await saveNote()
            tabIndex = 0
        }
        
        
    }
    
}
#Preview {
    NotebookView(settings: SettingsModel(), tabIndex: .constant(1), promptSelectedIndex: .constant(1), promptSelectedFromHome: .constant(false))
}

