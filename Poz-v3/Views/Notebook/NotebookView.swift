import SwiftUI
import Pages

struct NotebookView: View {

    @Binding var tabIndex: Int

    @State var indexNotes: Int = UserDefaults.standard.integer(forKey: "LastPageOpen")
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt,ascending: true)]
    ) var notes: FetchedResults<Note>

    @Binding var promptSelectedIndex: Int
    @Binding var promptSelectedFromHome: Bool
    
    @State var firstTimeShowing = true
    
    @State var showPageSlider = false
    @State var isEditing = true
    @State var pageNumber = 0.0
    
    @State var isLastPage = false
    
    var body: some View {
        
        ZStack {
                   
//            NoteTopMenuView(settings: settings, tabIndex: $tabIndex)
            
            ModelPages (

                notes, currentPage: $indexNotes,
                transitionStyle: .pageCurl,
                bounce: true,
                hasControl: false

            ) { pageIndex, note in
                
                NotePage(settings: settings, note: note, promptSelectedIndex: $promptSelectedIndex, promptSelectedFromHome: $promptSelectedFromHome, tabIndex: $tabIndex, showPageSlider: $showPageSlider, pageIndex: $indexNotes).environment(\.managedObjectContext, self.moc)
                    .onDisappear () {
                        UserDefaults.standard.set(indexNotes, forKey: "LastPageOpen")
                    }
            }
            .padding(.top, -6)
            
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
            if promptSelectedIndex != 0 {
                indexNotes = findFirstEmptyPage() - 1
            }
        }
        .onTapGesture {
            firstTimeShowing = false
        }
    }
    
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
