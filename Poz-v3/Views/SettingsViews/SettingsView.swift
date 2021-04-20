import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings: SettingsModel
    @State var darkMode = false
    @State var notifications = true
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var useAuth = UserDefaults.standard.bool(forKey: "useAuthentication")
    @State var isUnlocked = false
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Name")) {
                    TextField("\(settings.username)", text: $settings.username) { isEditing in
                        UserDefaults.standard.set(settings.username, forKey: "Username")
                    }
                }
                
                Section(header: Text("Customization")) {
                    NavigationLink(destination:  NotificationsView(settings: settings) ) {
                        HStack {
                            Text("Daily goal")
                        }
                    }
                    NavigationLink(destination: CustomizeJournalView(settings: settings)) {
                        HStack {
                            Text("Customize Journal")
                        }
                    }
                }
                
                Section(header: Text("Poz")) {
//                    NavigationLink(destination: FeedbackViewClean()) {
//                        HStack {
//                            Text("Feedback")
//                        }
//                    }
//                    NavigationLink(destination: Text("hi")) {
//                        HStack {
//                            Text("Rate Poz on the app store")
//                        }
//                    }
                    NavigationLink(destination:  WebView(link: "https://pozjournal.com/") ) {
                        HStack {
                            Text("Visit website")
                        }
                    }
                }
                
                
                Section(header: Text("Security")) {
                    Toggle("Face/Touch ID Login", isOn: $useAuth)
                        .onChange(of: useAuth) { value in
                            
                            UserDefaults.standard.set(useAuth, forKey: "useAuthentication")
                            
                            if useAuth {
                                AuthenticationModel(isUnlocked: $isUnlocked).authenticate()
                            }
                        }
                    
                    NavigationLink(destination: PrivacyPolicyView() ) {
                        HStack {
                            Text("Privacy")
                        }
                    }
                }
            }
            .font(Font.custom("Poppins-Light", size: 16))
            
            .navigationTitle( Text("Settings ⚙️"))
                
            .navigationBarItems(trailing: Button(action: {
//                self.settings.darkMode = self.darkMode
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
            }))
        }
        .preferredColorScheme((colorScheme == .dark ? (.dark) : (.light)))
        
    }
}
