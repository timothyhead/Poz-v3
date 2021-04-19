import SwiftUI

struct OnboardingView: View {
    @ObservedObject var settings: SettingsModel
    @Binding var tabIndex: Int
    @Environment(\.colorScheme) var colorScheme
    var doneFunction: () -> ()
    
    var slideCount = 6
    
    @State var slideGesture: CGSize = CGSize.zero
    @State var curSlideIndex = 0
    var distance: CGFloat = UIScreen.main.bounds.size.width
    
    @State var nameIsEntered = false
    
    @State var disabledButton = false
    
    @State var securitySettingSet = false
    
    @State var gatedAccess = 0
    
    func nextButton() {
        if self.curSlideIndex == slideCount - 1 {
            doneFunction()
            return
        }
        
        if self.curSlideIndex < slideCount - 1 {
            if !disabledButton {
                withAnimation {
                    self.curSlideIndex += 1
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            
            (Color(UIColor(named: "HomeBG")!)).edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .center) {
                OnboardingWelcome(settings: settings, tabIndex: $tabIndex)
                    .offset(x: 0 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                UserSettingsViewOnboard(settings: settings, nameIsEntered: $nameIsEntered)
                    .offset(x: 1 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                EnableAuthViewOnboard(moveForward: $securitySettingSet)
                    .offset(x: 2 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                NotificationsViewOnboard(settings: settings)
                    .offset(x: 3 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                CustomizeJournalViewOnboard(settings: settings)
                    .offset(x: 4 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                    .padding(.bottom, 80)
                OnboardingAllDone()
                    .offset(x: 5 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
            }
            .onChange(of: nameIsEntered) { value in
                if nameIsEntered == true {
                    gatedAccess = 1
                    disabledButton = false
                } else {
                    disabledButton = true
                }
            }
            .onChange(of: securitySettingSet) { value in
                if securitySettingSet == true {
                    disabledButton = false
                } else {
                    disabledButton = true
                }
            }
            .onChange(of: curSlideIndex) { value in
                
                if curSlideIndex == 1 && !nameIsEntered {
                    disabledButton = true
                } else if curSlideIndex == 1 && nameIsEntered {
                    disabledButton = false
                }
                if curSlideIndex  == 2 && !securitySettingSet {
                    disabledButton = true
                } else if curSlideIndex == 2 && securitySettingSet {
                    disabledButton = false
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    self.progressView()
                    Spacer()
                    Button(action: nextButton) {
                        self.arrowView()
                    }
                }
                
                .padding(20)
                .padding(.bottom, 10)
                .background(Color(UIColor(named: "HomeBG")!))
            }
        }
    }
    
    func arrowView() -> some View {
        Group {
            
            if self.curSlideIndex == slideCount - 1 {
                HStack {
                    Text("Get Started")
                        .font(Font.custom("Poppins-Light", size: 20))
                        .foregroundColor(Color(.black))
                }
                .frame(width: 180, height: 50)
                .background(Color(UIColor(named: "PozYellow")!))
                .cornerRadius(25)
            } else {
                
                    HStack {
                        Text("👉🏽")
                            .font(.system(size: 40))
                            .opacity(disabledButton ? 0.2 : 1)
                    }
                    .foregroundColor(Color(.black))
              
            }
            
        }
    }
    
    func progressView() -> some View {
        VStack {
            HStack {
                ForEach(0..<slideCount) { i in
                    Circle()
                        .scaledToFit()
                        .frame(width: 8)
                        .foregroundColor(self.curSlideIndex >= i ? (colorScheme == .dark ? Color.white : Color.black) : (colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2)))
                }
            }
            if (curSlideIndex != 0) {
                Button (action: {
                    withAnimation {
                            self.curSlideIndex -= 1
                    }
                }) {            
                    Text("👈🏽")
                        .font(.system(size: 20))
                }
            }
        }
        
    }
    
}

struct OnboardingWelcome: View {
    
    @ObservedObject var settings: SettingsModel
    @Binding var tabIndex: Int
    
    var body: some View {
        
        VStack (spacing: 0) {
            
            Text("Welcome to Poz")
                .font(Font.custom("Blueberry", size: 36))
                .foregroundColor(.primary)
                
            
            Text("Your personal mindfulness journal")
                .font(Font.custom("Poppins-Light", size: 18))
                .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
            
            Image("Alone").resizable().frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 30)
            
            Text("Click the 👉🏽 to get started")
                .font(Font.custom("Poppins-Light", size: 18))
                .foregroundColor(Color.primary)
                .padding(.top, 80)
            
        }
        .background((Color(UIColor(named: "HomeBG")!)))
        
    }
}

struct OnboardingAllDone: View {
    var body : some View {
        VStack (alignment: .center) {
            Text("All set!")
                .font(Font.custom("Blueberry", size: 36))
                .foregroundColor(.primary)
            
        
            Text("Welcome to Poz. Your personal mindfulness journal")
                .font(Font.custom("Poppins-Light", size: 18))
                .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
//                .padding(.bottom, 40)
            
//            VStack (spacing: 20){
//                Text("What you need to know:")
//                    .foregroundColor(Color.primary)
//
//                Text("Click on your journal 📔 to open it up")
//
//                Text("The 📪🔮💢🙏🏾 buttons are prompts")
//
//                Text("Use the 💬 to give feedback")
//
//                Text("Click the ⚙️ to adjust settings")
//            }
//            .font(Font.custom("Poppins-Light", size: 18))
//            .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
        }
        .padding(40)
        .multilineTextAlignment(.center)
    }
}
