import SwiftUI
import SwiftSpeech

//speech to text button - adapted from https://github.com/Cay-Zhang/SwiftSpeech

struct SwiftSpeechButtonView: View {
    
    var sessionConfiguration: SwiftSpeech.Session.Configuration
    
//    @Binding var output: String = ""!
    
    public init(sessionConfiguration: SwiftSpeech.Session.Configuration) {
        self.sessionConfiguration = sessionConfiguration
//        output = ""
    }
    public init(locale: Locale = .current) { self.init(sessionConfiguration: SwiftSpeech.Session.Configuration(locale: locale)) }
    public init(localeIdentifier: String) { self.init(locale: Locale(identifier: localeIdentifier)) }
    
    
    
    var body: some View {
        VStack {
        SwiftSpeech.RecordButton()
            .swiftSpeechToggleRecordingOnTap(sessionConfiguration: sessionConfiguration, animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
//                .onRecognizeLatest(update: $output)
            .scaleEffect(0.7)
            .padding(.horizontal, -12)
        }
        .onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
}

struct SwiftSpeechButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftSpeechButtonView()
    }
}
