import SwiftUI

struct OnboardingView: View {
    @ObservedObject var settings: SettingsModel
    @Binding var tabIndex: Int
    
    var doneFunction: () -> ()
    
    var slideCount = 4
    
    @State var slideGesture: CGSize = CGSize.zero
    @State var curSlideIndex = 0
    var distance: CGFloat = UIScreen.main.bounds.size.width
    
    func nextButton() {
        if self.curSlideIndex == slideCount - 1 {
            doneFunction()
            return
        }
        
        if self.curSlideIndex < slideCount - 1 {
            withAnimation {
                self.curSlideIndex += 1
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .center) {
                OnboardingWelcome(settings: settings, tabIndex: $tabIndex)
                    .offset(x: 0 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                    .gesture(DragGesture().onChanged { value in
                        self.slideGesture = value.translation
                    }
                    .onEnded { value in
                        if self.slideGesture.width < -50 {
                            if self.curSlideIndex < slideCount - 1 {
                                withAnimation {
                                    self.curSlideIndex += 1
                                }
                            }
                        }
                        if self.slideGesture.width > 50 {
                            if self.curSlideIndex > 0 {
                                withAnimation {
                                    self.curSlideIndex -= 1
                                }
                            }
                        }
                        self.slideGesture = .zero
                    })
                UserSettingsView(settings: settings)
                    .offset(x: 1 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                    .gesture(DragGesture().onChanged { value in
                        self.slideGesture = value.translation
                    }
                    .onEnded { value in
                        if self.slideGesture.width < -50 {
                            if self.curSlideIndex < slideCount - 1 {
                                withAnimation {
                                    self.curSlideIndex += 1
                                }
                            }
                        }
                        if self.slideGesture.width > 50 {
                            if self.curSlideIndex > 0 {
                                withAnimation {
                                    self.curSlideIndex -= 1
                                }
                            }
                        }
                        self.slideGesture = .zero
                    })
                CustomizeJournalView(settings: settings)
                    .offset(x: 2 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                    .gesture(DragGesture().onChanged { value in
                        self.slideGesture = value.translation
                    }
                    .onEnded { value in
                        if self.slideGesture.width < -50 {
                            if self.curSlideIndex < slideCount - 1 {
                                withAnimation {
                                    self.curSlideIndex += 1
                                }
                            }
                        }
                        if self.slideGesture.width > 50 {
                            if self.curSlideIndex > 0 {
                                withAnimation {
                                    self.curSlideIndex -= 1
                                }
                            }
                        }
                        self.slideGesture = .zero
                    })
                NotificationsView(settings: settings)
                    .offset(x: 3 * self.distance)
                    .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                    .animation(.spring())
                    .gesture(DragGesture().onChanged { value in
                        self.slideGesture = value.translation
                    }
                    .onEnded { value in
                        if self.slideGesture.width < -50 {
                            if self.curSlideIndex < slideCount - 1 {
                                withAnimation {
                                    self.curSlideIndex += 1
                                }
                            }
                        }
                        if self.slideGesture.width > 50 {
                            if self.curSlideIndex > 0 {
                                withAnimation {
                                    self.curSlideIndex -= 1
                                }
                            }
                        }
                        self.slideGesture = .zero
                    })
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
            }
            .padding(20)
            .padding(.bottom, 10)
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
//                    Text("next")
//                        .font(Font.custom("Poppins-Regular", size: 20))
                    Text("👉🏽")
                        .font(.system(size: 40))
                }
                .foregroundColor(Color(.black))
            }
        }
    }
    
    func progressView() -> some View {
        HStack {
            ForEach(0..<slideCount) { i in
                Circle()
                    .scaledToFit()
                    .frame(width: 8)
                    .foregroundColor(self.curSlideIndex >= i ? Color(.black) : (Color(.black).opacity(0.2)))
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
            
        }
        .background((Color(UIColor(named: "HomeBG")!)))
        
    }
}
