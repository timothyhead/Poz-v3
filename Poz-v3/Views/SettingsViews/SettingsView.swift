import SwiftUI

// main settings view

struct SettingsView: View {
    
    //settings, colorscheme, presentation mode
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    // for old manual dark mode toggle
    @State var darkMode = false
    
    // for notification control
    @State var notifications = true
    
    // for controlling authentication
    @State var useAuth = UserDefaults.standard.bool(forKey: "useAuthentication")
    @State var isUnlocked = false
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Name")) {
                    TextField("Enter name", text: $settings.username) { isEditing in
                        UserDefaults.standard.set(settings.username, forKey: "Username")
                    }
                    .disableAutocorrection(true)
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
                    Toggle("Lock noteboook", isOn: $useAuth)
                        .onChange(of: useAuth) { value in
                            
                            if value {
                                useAuth = AuthenticationModel(isUnlocked: $isUnlocked).authenticate()
                               // AuthenticationModel(isUnlocked: $isUnlocked).authenticateDo()
                                
                                UserDefaults.standard.set(useAuth, forKey: "useAuthentication")
//                                useAuth = isUnlocked
                                
                            } else {
                                UserDefaults.standard.set(useAuth, forKey: "useAuthentication")
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
            .onChange(of: settings.useAuthentication) { value in
                useAuth = value
            }
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
