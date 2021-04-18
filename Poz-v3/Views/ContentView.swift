import SwiftUI

 // https://github.com/exyte/ConcentricOnboarding

struct ContentView: View {
    
    @ObservedObject var settings = SettingsModel()
    @Environment(\.colorScheme) var colorScheme


    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt,ascending: true)]
//        predicate:  NSPredicate(format: "emoji != %@", "")
    
    ) var notes: FetchedResults<Note>
    
    @State var tabIndex = 0
    
    @State var firstTimeNotebookIndex = 0
    
    @State var promptSelectedIndex = 0
    
    @State var isUnlocked = false
    
    @State var firstTimeLaunched = true
    
    @State private var onboardingDone = true
    
    var body: some View {
            
            VStack {
                if isUnlocked {
                    
                    if tabIndex == 0 {
                        
                        Group {
                            if !onboardingDone {
                                OnboardingView(settings: settings, tabIndex: $tabIndex, doneFunction: {
                                    self.onboardingDone = true
                                    print("done onboarding")
                                })
                            } else {
                                HomeView(settings: settings, tabIndex: $tabIndex, promptSelectedIndex: $promptSelectedIndex).environment(\.managedObjectContext, self.moc)
                            }
                        }
                        
//                    } else if tabIndex == 0 {
//                        HomeView(settings: settings, tabIndex: $tabIndex, promptSelectedIndex: $promptSelectedIndex).environment(\.managedObjectContext, self.moc)
//                        
                    } else if tabIndex == 1 {
                        NotebookView(tabIndex: $tabIndex, settings: settings, promptSelectedIndex: $promptSelectedIndex, firstTimeLaunched: $firstTimeLaunched).environment(\.managedObjectContext, self.moc)
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
//                firstTimeLaunched = false
            } else {
//                firstTimeLaunched = true
                tabIndex = -1
                
                //create welcome message
                let welcomeNote = Note(context: self.moc)
                
                welcomeNote.id = UUID() //create id
                welcomeNote.emoji = "🗂️"
                welcomeNote.note = settings.welcomeText
                welcomeNote.createdAt = Date() //actual date to sort
                welcomeNote.date = "-"
                
                try? self.moc.save()
                
                //create welcome message
                for value in (0...100) {
                    let blankNote = Note(context: self.moc)
                        print(value)
                    blankNote.id = UUID() //create id
                    blankNote.note = ""
                    blankNote.createdAt = Date() //actual date to sort
                    blankNote.date = "-"

                    try? self.moc.save()
                }
                
                UserDefaults.standard.set(2, forKey: "goalNumber")
            }
        }
    }

    func isAppAlreadyLaunchedOnce()->Bool {
        let defaults = UserDefaults.standard

        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            
            firstTimeLaunched = false
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



