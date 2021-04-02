import SwiftUI

 // https://github.com/exyte/ConcentricOnboarding

struct ContentView: View {
    
    @ObservedObject var settings = SettingsModel()
    @Environment(\.colorScheme) var colorScheme

    @State var tabIndex = 0
    
    @State var firstTimeNotebookIndex = 0
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt,ascending: true)]
//        predicate:  NSPredicate(format: "emoji != %@", "")
    
    ) var notes: FetchedResults<Note>
    
    @State var promptSelectedIndex = 0
    
    @State var isUnlocked = true
    
    var body: some View {
            
            VStack {
                if isUnlocked {
                    
                    if tabIndex == -1 {
                        OnboardingView(settings: settings, tabIndex: $tabIndex)
                        
                    } else if tabIndex == 0 {
                        HomeView(settings: settings, tabIndex: $tabIndex, promptSelectedIndex: $promptSelectedIndex).environment(\.managedObjectContext, self.moc)
                        
                    } else if tabIndex == 1 {
                        NotebookView(tabIndex: $tabIndex, indexAdd: $firstTimeNotebookIndex, settings: settings, promptSelectedIndex: $promptSelectedIndex).environment(\.managedObjectContext, self.moc)
                    }
                    
                } else {
                    //Content to show while FaceID not validated
                }
            }
            .background(Color(UIColor(named: "HomeBG")!))
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .onAppear {
            
            if (isUnlocked == false) {
                AuthenticationModel(isUnlocked: $isUnlocked).authenticate()
            }
            
            if (isAppAlreadyLaunchedOnce()) {
                firstTimeNotebookIndex = 1
            } else {
                tabIndex = -1
                
//create new notes
                
                //create welcome message
                let welcomeNote = Note(context: self.moc)
                
                welcomeNote.id = UUID() //create id
                welcomeNote.emoji = "🗂️"
                welcomeNote.note = settings.welcomeText
                welcomeNote.hidden = false
                welcomeNote.createdAt = Date() //actual date to sort
                
                try? self.moc.save()
                
                //create welcome message
                for value in (0...(countNotes() + 50)) {
                    let blankNote = Note(context: self.moc)
                        print(value)
                    blankNote.id = UUID() //create id
                    blankNote.note = ""
                    blankNote.hidden = false
                    blankNote.createdAt = Date() //actual date to sort

                    try? self.moc.save()
                }
                
            }
        }
    }

    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard

        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
            
        } else {
            
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
            
        }
    }
    
    func countNotes () -> Int {
        var notesCount = 0
        
        for _ in notes {
            notesCount += 1
        }
        
        print(notesCount)
        return notesCount
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



