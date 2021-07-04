import SwiftUI
import EventKit

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
    
    @State var saveNotesToCal = UserDefaults.standard.bool(forKey: "saveToCal")
    
    @State var showingCalendarChooser = false
    let eventStore = EKEventStore()
    
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
                
                Section(header: Text("Integrations")) {
                    // calendar button
                    HStack {
//                        Button (action:{ showingCalendarChooser.toggle() }) {
//                            Text("Calendar")
//                                .foregroundColor(.black)
//                        }
//                        .sheet(isPresented: $showingCalendarChooser) {
//                            CalendarChooser(eventStore: eventStore)
//                        }
                        
                        Toggle("Sync to calendar", isOn: $saveNotesToCal)
                        .onChange(of: saveNotesToCal) { value in
                            UserDefaults.standard.set(saveNotesToCal, forKey: "saveToCal")
                        }
                    }
                }
                
                Section(header: Text("Security")) {
                    Toggle("Lock noteboook", isOn: $useAuth)
                        .onChange(of: useAuth) { value in
                            
                            if value {
                                UserDefaults.standard.set(settings.username, forKey: "saveToCal")
                                
                            } else {
                                UserDefaults.standard.set(settings.username, forKey: "saveToCal")
                            }
                            
                        }
                    
                    
                    NavigationLink(destination: PrivacyPolicyView() ) {
                        HStack {
                            Text("Privacy")
                        }
                    }
                }
                
                Section(header: Text("Poz")) {
//                    NavigationLink(destination: WebView(link: "itms-apps://itunes.apple.com/app/id1560847986") ) {
//                        //https://apps.apple.com/us/app/poz-journal/id1560847986?action=write-review
//                        HStack {
//                            Text("Rate Poz on the app store")
//                        }
//                    }
//                    
                    NavigationLink(destination: WebView(link: "https://pozjournal.com/") ) {
                        HStack {
                            Text("Visit website")
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
