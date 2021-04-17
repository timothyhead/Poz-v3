import SwiftUI
import UIKit
import MessageUI


struct FeedbackView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showMailSheet = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    var body: some View {
        
        if MFMailComposeViewController.canSendMail() {
            Rectangle().frame(width: 0, height: 0, alignment: .center)
            .onAppear() {
                if MFMailComposeViewController.canSendMail() {
                    showMailSheet = true
                }
            }
            
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
            Button( action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Close")
                    .font(Font.custom("Poppins-Regular", size: 20))
            }
        }
    }
}

//class FeedbackView: UIViewController, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate {
//
//    @Environment(\.presentationMode) var presentationMode
//
//    override func viewDidLoad() {
////        Button(action: { feedbackView() }) {
////            Text("Give Feedback")
////        }
//        super.viewDidLoad()
//        let button = UIButton()
//        view.addSubview(button)
//        button.setTitle("feedback", for: .normal)
//        button.addTarget(self, action: #selector(feedbackView), for: .touchUpInside)
//
////            WebView(link: "https://78dxgd9o34y.typeform.com/to/bpax2l9N")
////            WebView(link: "https://forms.gle/4SWfHXyq5KKaUbNR7")
//////                .foregroundColor(Color(UIColor(named: "PozGray")!))PozYellow
////            Button( action: { self.presentationMode.wrappedValue.dismiss() }) {
////                Text("Close")
////                    .font(Font.custom("Poppins-Regular", size: 20))
//    }
//
////    var body: some View {
////        VStack {
////
////            Button(action: { feedbackView() }) {
////                Text("Give Feedback")
////            }
//////            WebView(link: "https://78dxgd9o34y.typeform.com/to/bpax2l9N")
//////            WebView(link: "https://forms.gle/4SWfHXyq5KKaUbNR7")
////////                .foregroundColor(Color(UIColor(named: "PozGray")!))PozYellow
//////            Button( action: { self.presentationMode.wrappedValue.dismiss() }) {
//////                Text("Close")
//////                    .font(Font.custom("Poppins-Regular", size: 20))
////           .padding()
////        }
////    }
//
//    @objc private func feedbackView() {
//        let vc = MFMailComposeViewController()
//        vc.delegate = self
//        vc.setSubject("Poz feedback")
//        vc.setToRecipients(["kishparikh18@gmail.com"])
//        vc.setMessageBody("hi", isHTML: false)
//        present(UINavigationController(rootViewController: vc), animated: true)
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//
//    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//
//    }
//}
