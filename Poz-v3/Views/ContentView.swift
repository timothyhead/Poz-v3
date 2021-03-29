import SwiftUI

 // https://github.com/exyte/ConcentricOnboarding

struct ContentView: View {
    
    @ObservedObject var settings = SettingsModel()
    @Environment(\.colorScheme) var colorScheme

    @State var tabIndex = 0
    
    @State var firstTimeNotebookIndex = 0
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            
            
            if tabIndex == 0 {
                HomeView(settings: settings, tabIndex: $tabIndex).environment(\.managedObjectContext, self.moc)
                
            } else if tabIndex == 1 {
                NotebookView(tabIndex: $tabIndex, indexAdd: $firstTimeNotebookIndex, settings: settings).environment(\.managedObjectContext, self.moc)
            }
           
            
        }
//        .preferredColorScheme((settings.darkMode == true ? (.dark) : (.light)))
        .background(Color(UIColor(named: "HomeBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .onAppear {
            
            
            if (isAppAlreadyLaunchedOnce()) {
                firstTimeNotebookIndex = 1
            } else {
                let note = Note(context: self.moc)
                
                note.id = UUID() //create id
                note.note = settings.welcomeText
                //input message
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



