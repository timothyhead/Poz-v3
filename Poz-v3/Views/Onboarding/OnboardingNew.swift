import SwiftUI
import Pages

struct OnboardingNew: View {
    
    @State var index = 0
    @ObservedObject var settings: SettingsModel
    @State var message: String?
    @Binding var tabIndex: Int
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        VStack (spacing: 0) {
            
            Text("Welcome to Poz")
                .font(Font.custom("Blueberry", size: 36))
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                
            
            Text("Your personal mindfulness journal")
                .font(Font.custom("Poppins-Light", size: 18))
                .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
            
            Image("Alone").resizable().frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 30)
            
            Button (action: { tabIndex = 0 }) {
                ZStack {
                    Text("Get started")
                }
                .foregroundColor(.black)
                .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color(#colorLiteral(red: 0.980877459, green: 0.8209024072, blue: 0.5006054044, alpha: 1)))
                .cornerRadius(100)
            }
            
        }.padding(.all, 20)
        
        
//        Pages (
//
//            currentPage: $index,
//            transitionStyle: .pageCurl
//
//        ) {
//
//            onboardingOne()
////
////            changeNameView(settings: settings)
////
////            onboardJournal(settings: settings)
//
//            VStack {
//                Text("These are entries, work just like a journal")
//                Text("Swipe right to get into the app")
//
//                Button (action: { tabIndex = 0 }) {
//                    Text("get into the app")
//                }
//            }
//            .frame(width: 400, height: 900).background(Color.yellow)


    }
}

struct onboardingOne: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                
                Spacer()
                
                Text("Poz")
                    .font(Font.custom("Blueberry", size: 36))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    
                
                Text("A mindfulness journal in your pocket.")
                    .font(Font.custom("Poppins-Light", size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
                
                Spacer()
                Spacer()
                LottieView(fileName: "swipe-simple")
                    .frame(width: 300, height: 200)
                    .colorInvert()
               
                Text("Just 4 quick steps to get you started.")
                    .font(Font.custom("Poppins-Light", size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color(#colorLiteral(red: 1, green: 0.9755830169, blue: 0.9413170218, alpha: 1))).edgesIgnoringSafeArea(.all)
            
            Image("book").resizable()
                .frame(width: 180, height: 250)
                .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 5, x: 0.0, y: 10)
                .shadow(color: (colorScheme == .dark ? Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))), radius: 20, x: 0.0, y: 15)
                .hueRotation(Angle(degrees: 120))
                .offset(y: -20)
        }
    }
}

struct changeNameView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @State var isEditing = false
    @State var name = ""
    
    var body: some View {
        
        VStack (alignment: .center) {
            Spacer()
            
            Text ("What's your name?")
                .font(Font.custom("Blueberry", size: 24))
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .padding(.bottom, -2)

            ZStack {
                TextField("Your first name will do", text: $name) { isEditing in
                    self.isEditing = isEditing
                    UserDefaults.standard.set(name, forKey: "Username")
                }
                .multilineTextAlignment(.center)
                .font(Font.custom("Poppins-Regular", size: 18))
                .onChange(of: isEditing) { value in
                    if !isEditing {
                        settings.username = name
                    }
                }
            }
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(#colorLiteral(red: 0.9350871444, green: 0.9900041223, blue: 1, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            hideKeyboard() //hide keyboard when user taps outside text field
        }
    }
}

struct onboardJournal: View {
    
    @ObservedObject var settings: SettingsModel
    @State var editingJournal = false
    
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
                
                Text("This is your journal")
                    .font(Font.custom("Blueberry", size: 24))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    
                Text("Fully customizable, and the home for all your journal entries.")
                    .font(Font.custom("Poppins-Light", size: 18))
                    .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .multilineTextAlignment(.center)
            
            VStack {
                BookStaticView(settings: settings, bookPatternIndex: $settings.journalPatternIndex)
                    .padding(.vertical, 40)
                    
                Button (action: { editingJournal.toggle() }) {
                    Text("Customize Journal")
                }
                .sheet(isPresented: $editingJournal, content: { CustomizeJournalView(settings: settings) })
            }
            .padding(.bottom, 10)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(#colorLiteral(red: 1, green: 0.9755830169, blue: 0.9413170218, alpha: 1)))
    }
}
