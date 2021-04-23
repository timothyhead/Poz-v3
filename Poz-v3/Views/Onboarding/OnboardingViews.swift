import SwiftUI

struct OnboardingView: View {
    
    // pass in settings & get colorscheme
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    
    // navigation control var
    @Binding var tabIndex: Int
    
    // slide management
    var slideCount = 6
    @State var curSlideIndex = 0
    
    // for slide animations
    @State var slideGesture: CGSize = CGSize.zero
    var distance: CGFloat = UIScreen.main.bounds.size.width
    
    // for checking if screens have been completed
    @State var nameIsEntered = false
    @State var securitySettingSet = false
    
    // for disabling next button
    @State var disabledButton = false
    
    // done function initialization
    var doneFunction: () -> ()
    
    // next buttons
    func nextButton() {
        
        // if last slide, be done
        if self.curSlideIndex == slideCount - 1 {
            doneFunction()
            return
        }
        
        // if not last slide, go to next slide
        if self.curSlideIndex < slideCount - 1 {
            
            // if button not disabled
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
                    .padding(.bottom, 40)
                EnableAuthViewOnboard(settings: settings, moveForward: $securitySettingSet)
                    .offset(x: 2 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                    .padding(.bottom, 40)
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
                    .padding(.bottom, 40)
            }
            
            // disabled button management
            
            // update disabled button when name entered
            .onChange(of: nameIsEntered) { value in
                if nameIsEntered == true {
                    disabledButton = false
                } else {
                    disabledButton = true
                }
            }
            
            // update disabled button when authentication setting set
            .onChange(of: securitySettingSet) { value in
                if securitySettingSet == true {
                    disabledButton = false
                } else {
                    disabledButton = true
                }
            }
            
            // on change of slide, check whtehre button sgould be disabled
            .onChange(of: curSlideIndex) { value in
                
                if curSlideIndex == 0 {
                    disabledButton = false
                }
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
            
            // bottom nav, back button and  next button
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
    
    // next button view, that is dynamic based on which slide
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
    
    // back button and slide nav view, that is dynamic based on which slide
    func progressView() -> some View {
        VStack {
            
            // generate circles and fill in some based on which slide
            HStack {
                ForEach(0..<slideCount) { i in
                    Circle()
                        .scaledToFit()
                        .frame(width: 8)
                        .foregroundColor(self.curSlideIndex >= i ? (colorScheme == .dark ? Color.white : Color.black) : (colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2)))
                }
            }
            
            // back button
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

//welcome screen
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
            
            // this image from https://storyset.com/
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


// last slide of onboardings
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
