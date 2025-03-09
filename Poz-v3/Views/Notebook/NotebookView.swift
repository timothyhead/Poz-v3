import SwiftUI
import PagesLocal

// notebook that displays all journal entries in page turn style
// using pages library by https://github.com/nachonavarro/Pages

struct NotebookView: View {
    
    // main nav var
    @Binding var tabIndex: Int

    // get the last page that was open from user defaults
    @State var indexNotes: Int = UserDefaults.standard.integer(forKey: "LastPageOpen")
    
    // settings, color scheme
    @ObservedObject var settings: SettingsModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt,ascending: true)] // notes sorted from first created to last
    ) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TempNoteData.messageId,ascending: true)]) var tempData: FetchedResults<TempNoteData>

    // for prompts, not in use
    @Binding var promptSelectedIndex: Int
    @Binding var promptSelectedFromHome: Bool
    
    // for onboarding
    @State var firstTimeShowing = true
    
    //for page slider
    @State var showPageSlider = false
    @State var isEditing = true
    @State var pageNumber = 0.0
    
    // for last page detection, not in use
    @State var isLastPage = false
    // for updating notes
    @State private var k: Constants = Constants.shared
    @State private var defaults = UserDefaults.standard
    //sheet in toolbar for search bar
    @State var prevPostsShowing = false
    
    var body: some View {
        
        ZStack {
                   
//            NoteTopMenuView(settings: settings, tabIndex: $tabIndex)
            
            // dynamic page system of all note objects in array of core data
            ModelPages (

                notes, currentPage: $indexNotes,
                transitionStyle: .pageCurl,
                bounce: true,
                hasControl: false

            ) { pageIndex, note in
                
                // note page, passing in almost everything possible
                NotePage(settings: settings, note: note, promptSelectedIndex: $promptSelectedIndex, promptSelectedFromHome: $promptSelectedFromHome, tabIndex: $tabIndex, showPageSlider: $showPageSlider, pageIndex: $indexNotes).environment(\.managedObjectContext, self.moc)
                    .onDisappear () {
                        // when notebook closes, save last open page
                        UserDefaults.standard.set(indexNotes, forKey: "LastPageOpen")
                    }
            }
            .padding(.top, -6)
            // MARK: - make new note on the page that has been turned away from when the page is turned. ie. not the new page but the last one.
            .onChange(of: defaults.bool(forKey: k.pageTurned) ) { _ in
                
              
                // The message and data from within the ModelPages struct in the tempData core data object
                let message = tempData.first(where:  { $0.messageId == k.messageId } )?.tempMessage ?? "no message"
                let emoji = tempData.first(where:  { $0.messageId == k.messageId } )?.emoji ?? "no message"
                let noteId =  tempData.first(where:  { $0.messageId == k.messageId} )?.noteId
                let lastUpdated = tempData.first(where:  { $0.messageId == k.messageId } )?.lastUpdated
                let prompt = tempData.first(where:  { $0.messageId == k.messageId } )?.prompt
                let date = tempData.first(where:  { $0.messageId == k.messageId } )?.date
                
                // update the note that was added to or add the new message and data on the new note  which was created in the block below in this onchange f: defaults.bool(forKey: k.pageTurned
                notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.note = message
                notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.emoji = emoji
                notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.prompt = prompt
                notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.lastUpdated = lastUpdated
                notes.first(where: { $0.id?.uuidString == noteId ?? "No id" })?.date = date
                try? moc.save()
                
                // make a new note so the Modelpages has a page to turn to. This will be updated in the above code if the page this on is turned to with a new page turn
                // only create a new note if there isn't one created. So with a back turn there will one always. With a forward turn if the note updated in  the block above  is the last to be created it will equal 'notes.last' . Notes are filtered by createdAt. So a  new note is created then.
                if indexNotes > defaults.integer(forKey: k.lastIndex) && notes.first(where: { $0.id?.uuidString == noteId ?? "No id" }) == notes.last {
                    let note = Note(context: moc)
                    note.id = UUID()
                    note.note = ""
                    note.createdAt = Date()
                    try? moc.save()
                }
                
                // sets the page of the current index so with a new page turn the if statement above can use it
                    defaults.set(indexNotes, forKey: k.lastIndex)
            
            }
            
            // page turn slider
            if showPageSlider {
                
                ZStack {
                    
                    if (isEditing || showPageSlider) {
                        Text("\(Int(pageNumber) + 1)")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .offset(x: 74, y: 41)
                    }
                
                    Slider(
                        value: $pageNumber,
                        in: 0...Double(notes.count - 1),
                        onEditingChanged: { editing in
                            isEditing = editing
                            indexNotes = Int(pageNumber)
                            if !isEditing {
                                showPageSlider = false
                            }
                        }
                    )
                }
                .onAppear() {
                    pageNumber = Double(indexNotes)
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
        .onChange(of: indexNotes) { value in
//                        if note.note != "" || note.emoji != "" {
            isLastPage = isCurrNoteLastPage()
            pageNumber = Double(indexNotes)
//                        }
        }
        .onChange(of: pageNumber) { value in
            indexNotes = Int(pageNumber)
        }
        .onAppear() {
            
            // initialize notebook page to last opened page
            if promptSelectedIndex != 0 {
                indexNotes = findFirstEmptyPage() - 1
            }
        }
        .onTapGesture {
            
            // close onboarding on click
            firstTimeShowing = false
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
    
    // check if curr page is the last page
    func isCurrNoteLastPage () -> Bool {
           
        if (indexNotes == notes.count - 1) {
            
//            if (notes[notes.count-1].note != "") {
                print("creating new page")
                let blankNote = Note(context: self.moc)
                blankNote.id = UUID() //create id
                blankNote.note = ""
                blankNote.createdAt = Date() //actual date to sort
                blankNote.date = "-"

                try? self.moc.save()
//            } else {
//                print("type something to add new page")
//            }
            
            return true
        } else {
            return false
        }
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
        return noteIndex
    }
}
