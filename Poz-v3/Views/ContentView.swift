import SwiftUI

struct ContentView: View {
    
    // initialize setting model
    @ObservedObject var settings = SettingsModel()
    
    // device color scheme (dark vs light mode)
    @Environment(\.colorScheme) var colorScheme
    
    // get core date notes
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt,ascending: true)]
    
    ) var notes: FetchedResults<Note>
    
    // primary navigational index
    @State var tabIndex = 0
    
    // for opening prompts from home screen, currently not in use
    @State var promptSelectedIndex = 0
    @State var promptSelectedFromHome = false
    
    // for authentication
    @State var isUnlocked = false
    @State var isAuthenticateOn = false
    
    // for onboarding/initial setup on first launch
    @State var firstTimeNotebookIndex = 0
    @State var firstTimeLaunched = true
    @State private var onboardingDone: Bool = UserDefaults.standard.bool(forKey: "onboardingDone")
    
    var body: some View {
            
            VStack {
                
                // if phone is unlocked or if its the first time, then only show content
                if isUnlocked || firstTimeLaunched {
                    
                    if tabIndex == 0 {
                        
                        Group {
                            if !onboardingDone {
                                
                                //onboarding
                                OnboardingView(settings: settings, tabIndex: $tabIndex, doneFunction: {
                                    self.onboardingDone = true
                                    UserDefaults.standard.set(true, forKey: "onboardingDone")
                                    print("done onboarding")
                                })
                            } else {
                                
                                // home view
                                HomeView(settings: settings, tabIndex: $tabIndex, promptSelectedIndex: $promptSelectedIndex, promptSelectedFromHome: $promptSelectedFromHome).environment(\.managedObjectContext, self.moc)
                            }
                        }
                        
                    } else if tabIndex == 1 {
                        
                        // notebook
                        NotebookView(tabIndex: $tabIndex, settings: settings, promptSelectedIndex: $promptSelectedIndex, promptSelectedFromHome: $promptSelectedFromHome).environment(\.managedObjectContext, self.moc)
                    }
                    
                } else {
                    
                    // Content to show when authentication is not unlocked and not first time using
                    
//                    Text("Poz Journal")
//                        .font(Font.custom("Blueberry", size: 32))
//                        .foregroundColor(Color.primary)
                }
            }
            .background(Color(UIColor(named: "HomeBG")!))
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .onAppear {
                
                // when this first screen loads, check if its the first time launched
                if (isAppAlreadyLaunchedOnce()) {
                    
                    // if its not the first time, onboarding is done and use authentication is turned on
                    if onboardingDone && settings.useAuthentication {
                        
                        // authenticate
                        AuthenticationModel(isUnlocked: $isUnlocked).authenticateDo() 
                         
                    } else {
                        // else unlock and let them through
                        isUnlocked = true
                    }
                    
                    // open notebook to page 1
                    firstTimeNotebookIndex = 1
                    firstTimeLaunched = false
                    
                } else {
                    // if first time opening
                    
                    firstTimeLaunched = true
                        
                    //create onboarding note
                    let welcomeNote = Note(context: self.moc)
                    
                    welcomeNote.id = UUID() //create id
                    welcomeNote.emoji = "🗂️"
                    welcomeNote.note = settings.welcomeText
                    welcomeNote.createdAt = Date() //actual date to sort
                    welcomeNote.date = "-"
                        
                    try? self.moc.save()
                    
                    //create one blank note
                    for value in (0...1) {
                        let blankNote = Note(context: self.moc)
                        print(value)
                        blankNote.id = UUID() //create id
                        blankNote.note = ""
                        blankNote.createdAt = Date() //actual date to sort
                        blankNote.date = "-"

                        try? self.moc.save()
                    }
            }
        }
    }

    // check if app has already launched one
    func isAppAlreadyLaunchedOnce()->Bool {
        
        // user defaults
        let defaults = UserDefaults.standard

        // checks if userdefaults has "isAppAlreadyLaunchedOnce" string
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            
            // if it does, return not first time
            firstTimeLaunched = false
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
            
        } else {
            
            // if not, return first time and save "isAppAlreadyLaunchedOnce" to user defaults
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
            
        }
    }
    
    
    // return number of notes, not in use
    func countNotes () -> Int {
        var notesCount = 0
        
        for _ in notes {
            notesCount += 1
        }
        
        print(notesCount)
        return notesCount
    }
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}



