import SwiftUI

struct UserSettingsView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @State var isEditing = false
    @State var useAuth = UserDefaults.standard.bool(forKey: "useAuthentication") 
    @State var isUnlocked = false
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Form {
                Section(header: Text("Name")) {
                    TextField("\(settings.username)", text: $settings.username) { isEditing in
                        self.isEditing = isEditing
                        UserDefaults.standard.set(settings.username, forKey: "Username")
                    }
                }
                
                Section(header: Text("Security")) {
                    Toggle("Face/Touch ID Login", isOn: $useAuth)
                        .onChange(of: useAuth) { value in
                            
                            UserDefaults.standard.set(useAuth, forKey: "useAuthentication")
                            
                            if useAuth {
                                AuthenticationModel(isUnlocked: $isUnlocked).authenticateDo()
                                
                                if (isUnlocked) {
                                    useAuth = true
                                } else {
                                    useAuth = false
                                }
                            }
                        }
                        .onAppear() {
                            useAuth = settings.useAuthentication
                        }
                }
            }.navigationTitle("Name & Security 👤")
        }
        .onTapGesture {
            hideKeyboard() //hide keyboard when user taps outside text field
        }
    }
}


struct UserSettingsViewOnboard: View {
    
    @ObservedObject var settings: SettingsModel
    
    @Binding var nameIsEntered: Bool
    
    @State var isEditing = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack (alignment: .center) {
            
            Text("Your name")
                    .font(Font.custom("Blueberry", size: 28))
                    .foregroundColor(.primary)
            Text("There’s just a few things to set up before you can jump into Poz. Let’s begin with your name.")
                    .font(Font.custom("Poppins-Light", size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
                .padding(.bottom, 100)
            
            TextField("Type your name here", text: $settings.username) { isEditing in
                self.isEditing = isEditing
                UserDefaults.standard.set(settings.username, forKey: "Username")
                
            }
            .disableAutocorrection(true)
            .padding(10)
            .background(colorScheme == .dark ? Color(#colorLiteral(red: 0.3082331717, green: 0.3096653819, blue: 0.3131458759, alpha: 1)) : Color(#colorLiteral(red: 0.888705194, green: 0.8834225535, blue: 0.892766118, alpha: 1)))
            .font(Font.custom("Poppins-Regular", size: 18))
            .cornerRadius(10)
            .onChange(of: settings.username) { value in
                if settings.username != "" {
                    nameIsEntered = true
                } else {
                    nameIsEntered = false
                }
            }
            
            Text("(you can update always this later)")
                .font(Font.custom("Poppins-Light", size: 16))
                .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
                .padding(.vertical, 10)
            
            Spacer()
        }
        .background(Color(UIColor(named: "HomeBG")!))
        .onTapGesture {
            hideKeyboard() //hide keyboard when user taps outside text field
        }
        .onAppear() {
            settings.username = ""
            nameIsEntered = false
        }
        .padding(.top, 100)
        .multilineTextAlignment(.center)
        .padding()
    }
}
