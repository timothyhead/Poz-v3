import SwiftUI

 // https://github.com/exyte/ConcentricOnboarding

struct ContentView: View {
    
    @ObservedObject var settings = SettingsModel()
    @Environment(\.colorScheme) var colorScheme

    @State var tabIndex = 0
    
    @State var firstTimeNotebookIndex = 0
    
    @Environment(\.managedObjectContext) var moc
    
    @State var promptSelectedIndex = 0
    
    @State var isUnlocked = false
    
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
                
                //create welcome message
                let note = Note(context: self.moc)
                
                note.id = UUID() //create id
                note.note = settings.welcomeText
                note.hidden = false
                note.createdAt = Date() //actual date to sort
                
                try? self.moc.save()
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



