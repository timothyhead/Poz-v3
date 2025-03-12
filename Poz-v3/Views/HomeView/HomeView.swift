import SwiftUI

// main home screen with book, good morning text, feedback, settings, and daily goal

struct HomeView: View {
    
    // get core data and color scheme
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    
    // pass in settings
    @ObservedObject var settings: SettingsModel
    
    // main nav control
    @Binding var tabIndex: Int
    
    // if book is being opened
    @State var bookOpenAnimation = false
    
    // open prompts from home, not in use
    @Binding var promptSelectedIndex: Int
    @Binding var promptSelectedFromHome: Bool
    
    // for feedback view
    @State var feedbackFormShowing = false
    
    // for onboarding
    @State var firstTimeShowing = true
    
    // for goal view
    @State var dailyGoalSheetShowing = false

    var body: some View {
        
        ZStack {
            
            VStack (alignment: .leading, spacing: 0) {
                
                // hides if book is opening
                if !bookOpenAnimation {
                    
                    //top bar
                    HStack (alignment: .top, spacing: 20) {
                        
                        //Hello Text
                        VStack (alignment: .leading, spacing: 0) {
                            Text( timeOfDayOutput() )
                                .font(Font.custom("Poppins-Light", size: 26))
                                .foregroundColor(Color(UIColor(named: "PozGray")!))
                            Text("\(settings.username)")
                                .font(Font.custom("Poppins-Medium", size: 26))
                            
                        }
                        
                        Spacer()
                        
                        // feedback button
                        Button (action: { feedbackFormShowing.toggle() }) {
                            Text("💬")
                                .font(Font.custom("Poppins-Light", size: 26))
                                .foregroundColor(.primary)
                        }
                        .sheet(isPresented: $feedbackFormShowing, content: { FeedbackView() })
                        
                        //settins button
                        Button (action:{ self.settings.showSettings.toggle() }) {
                            Text("⚙️")
                                .font(Font.custom("Poppins-Light", size: 26))
                                .foregroundColor(Color(UIColor(named: "PozGray")!))
                        }
                        .sheet(isPresented: $settings.showSettings, content: {
                            SettingsView(settings: self.settings)
                                    .environment(\.managedObjectContext, self.moc)
                        })
                        
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                //book
                BookView(settings: settings, tabIndex: $tabIndex, isOpening: $bookOpenAnimation, promptSelectedIndex: $promptSelectedIndex, promptSelectedFromHome: $promptSelectedFromHome).environment(\.managedObjectContext, self.moc)
                
                Spacer()
                
                // hides if book is opening
                if !bookOpenAnimation {
                    
                    // daily goal view
                    Button (action: { dailyGoalSheetShowing = true }) {
                        BarGoalView(settings: settings)
                    }
                    .sheet(isPresented: $dailyGoalSheetShowing) {
                        NotificationsViewPopup(settings: settings)
                    }
                }
            }
            .padding(.top, 60).padding(.bottom, 30)
            .background(Color(UIColor(named: "HomeBG")!))
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            .onAppear() {
                promptSelectedIndex = 0
            }

            // show onboarding tutorial first time opened
            if (firstTimeShowing) {
                HomeViewTutorial(show: firstTimeShowing)
                    .onAppear() {
                        firstTimeShowing = firstTimeAppearing()

                        // auto dismiss after 5 s
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                            withAnimation (.easeOut) {
//                                firstTimeShowing = firstTimeAppearing()
//                            }
//                        }
                    }
            }
        }
        .onTapGesture {
            
            // dismisses onboarding on click
            firstTimeShowing = false
        }
    }
    
    //checks if first time appearing, same of content view
    func firstTimeAppearing()->Bool{
        let homeScreendefaults = UserDefaults.standard

        if let firstTimeAppearing = homeScreendefaults.string(forKey: "firstTimeAppearing"){

            print("Screen already launched : \(firstTimeAppearing)")
            return false

        } else {
            
            homeScreendefaults.set(true, forKey: "firstTimeAppearing")
            print("Screen launched first time")
            return true

        }
    }
    
    // checks time of day and returns appropriate greeting
    func timeOfDayOutput () -> String {
        
        let currentTime = Calendar.current.component( .hour, from:Date() )
        
        if (currentTime < 12) {
            return settings.username != "" ? "Good morning," : "Good morning"
        } else if (currentTime >= 12 && currentTime < 17) {
            return settings.username != "" ? "Good afternoon," : "Good afternoon"
        } else if (currentTime >= 17 && currentTime < 20) {
            return settings.username != "" ? "Good evening," : "Good evening"
        } else {
            return settings.username != "" ? "Good night," : "Good night"
        }
    }
}
