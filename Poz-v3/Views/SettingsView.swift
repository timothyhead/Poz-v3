import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @State var darkMode = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("Your journal")) {
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Your data")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Privacy")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Passwords/Face ID")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Accessibility")
                        }
                    }
                }
                
                Section(header: Text("Customization")) {
                    Toggle(isOn: $darkMode, label: {
                        Text("Dark Mode")
                    })
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Customize Journal")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Accessibility")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("App Icon")
                        }
                    }
                }
                
                Section(header: Text("Community")) {
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Share Poz")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Rate us on app store")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Visit website")
                        }
                    }
                }
                
                Section(header: Text("Application")) {

                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Request a feature")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Feedback / Contact Us")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Terms of Service")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Privacy")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("FAQ")
                        }
                    }
                    NavigationLink(destination: Text("hi")) {
                        HStack {
                            Text("Acknowledgements")
                        }
                    }
                }
            }
            .font(Font.custom("Poppins-Light", size: 16))
            
            .navigationTitle( Text("Settings"))
                
            .navigationBarItems(trailing: Button(action: {
                self.settings.darkMode = self.darkMode
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
            }))
        }
        .preferredColorScheme((darkMode == true ? (.dark) : (.light)))
        .onAppear(perform: {
            self.darkMode = self.settings.darkMode
        })
        
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
