import SwiftUI
import UIKit
import MessageUI


struct FeedbackView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showMailSheet = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    @State var useGoogleForm = false
    
    var body: some View {
        ZStack {
            VStack {
            
            if MFMailComposeViewController.canSendMail() && !useGoogleForm {
                
                if (showMailSheet) {
                    MailView(result: self.$result, newSubject: "Poz Feedback 💬",
                             newMsgBody: """
                                         I had an issue with…
                                         I wanted to tell you that…
                                         I wanted to suggest a feature…
                                         """)
                }
                
            } else {
                WebView(link: "https://forms.gle/4SWfHXyq5KKaUbNR7")
                    .onAppear() {
                        useGoogleForm = true
                    }.padding(.top, 60)
            }
            
            
            if MFMailComposeViewController.canSendMail() {
                Picker(selection: $useGoogleForm, label: Text("Random or manual time?")) {
                    Text("Email").tag(false)
                    Text("Google Form").tag(true)
                }
                .font(Font.custom("Poppins-Regular", size: 16))
                .pickerStyle(SegmentedPickerStyle())
                .onAppear() {
                    if MFMailComposeViewController.canSendMail() {
                        showMailSheet = true
                    }
                }
                .padding()
            }
            
        }
            
            HStack {
                
            Button( action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Done")
//                    .font(Font.custom("Poppins-Regular", size: 20))
            }
            .padding(.top, 2)
            .padding(20)
                Spacer()
            }
            .background((Color(UIColor(named: "HomeBG")!)))
            .offset(x: 0, y: 75-UIScreen.main.bounds.height/2)
        }
    }
}

struct FeedbackViewClean: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showMailSheet = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    @State var useGoogleForm = false
    
    var body: some View {
        NavigationView {
//            VStack {
            
            if MFMailComposeViewController.canSendMail() && !useGoogleForm {
                
                if (showMailSheet) {
                    MailView(result: self.$result, newSubject: "Poz Feedback",
                             newMsgBody: """
                                         I had an issue with…
                                         I wanted to tell you that…
                                         I wanted to suggest a feature…
                                         """)
                }
                
            } else {
                WebView(link: "https://forms.gle/4SWfHXyq5KKaUbNR7")
                    .onAppear() {
                        useGoogleForm = true
                    }
            }
            
            
            if MFMailComposeViewController.canSendMail() {
                Picker(selection: $useGoogleForm, label: Text("Random or manual time?")) {
                    Text("Email").tag(false)
                    Text("Google Form").tag(true)
                }
                .font(Font.custom("Poppins-Regular", size: 16))
                .pickerStyle(SegmentedPickerStyle())
                .onAppear() {
                    if MFMailComposeViewController.canSendMail() {
                        showMailSheet = true
                    }
                }
                .padding()
            }
            
//        }

//            HStack {
//                
//                Button( action: { self.presentationMode.wrappedValue.dismiss() }) {
//                    Text("Cancel")
//    //                    .font(Font.custom("Poppins-Regular", size: 20))
//                }
//                .padding(.top, 2)
//                .padding(20)
//                    Spacer()
//            }
//            .background((Color(UIColor(named: "HomeBG")!)))
//            .offset(x: 0, y: 75-UIScreen.main.bounds.height/2)
        }
        .navigationBarItems(trailing: Button(action: {
//                self.settings.darkMode = self.darkMode
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Done")
        }))
    }
}
