import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings: SettingsModel
    @State var darkMode = false
    @State var notifications = true
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header: Text("Customization")) {
                    NavigationLink(destination: UserSettingsView(settings: settings) ) {
                        HStack {
                            Text("Name")
                        }
                    }
                    NavigationLink(destination:  NotificationsView(settings: settings) ) {
                        HStack {
                            Text("Daily goal")
                        }
                    }
//                    Toggle(isOn: $darkMode, label: {
//                        Text("Dark Mode")
//                    })
                    NavigationLink(destination: CustomizeJournalView(settings: settings)) {
                        HStack {
                            Text("Customize Journal")
                        }
                    }
                }
                
                Section(header: Text("Community")) {
//                    NavigationLink(destination: Text("hi")) {
//                        HStack {
//                            Text("Share Poz")
//                        }
//                    }
//                    NavigationLink(destination: Text("hi")) {
//                        HStack {
//                            Text("Rate Poz on the app store")
//                        }
//                    }
                    NavigationLink(destination:  WebView(link: "https://pozjournal.webflow.io/") ) {
                        HStack {
                            Text("Visit website")
                        }
                    }
                }
                
                Section(header: Text("Application")) {
                    
                    NavigationLink(destination: FeedbackView() ) {
                        HStack {
                            Text("Feedback / Contact Us")
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
            
            .navigationTitle( Text("Settings"))
                
            .navigationBarItems(trailing: Button(action: {
//                self.settings.darkMode = self.darkMode
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
            }))
        }
//        .preferredColorScheme((darkMode == true ? (.dark) : (.light)))
        .preferredColorScheme((colorScheme == .dark ? (.dark) : (.light)))
//        .onAppear(perform: {
//            self.darkMode = self.settings.darkMode
//        })
        
    }
}
