import SwiftUI
import SwiftSpeech

//speech to text button - adapted from https://github.com/Cay-Zhang/SwiftSpeech

struct SwiftSpeechButtonView: View {
    
    var sessionConfiguration: SwiftSpeech.Session.Configuration
    
    @Binding var output: String
    
    public init(sessionConfiguration: SwiftSpeech.Session.Configuration, output: Binding<String>) {
        self.sessionConfiguration = sessionConfiguration
        self._output = output
    }
    public init(locale: Locale = .current, output: Binding<String>) {
        self.init(sessionConfiguration: SwiftSpeech.Session.Configuration(locale: locale), output: output)
    }
    public init(localeIdentifier: String, output: Binding<String>) {
        self.init(locale: Locale(identifier: localeIdentifier), output: output)
    }
    
    var body: some View {
        VStack {
        SwiftSpeech.RecordButton()
            .swiftSpeechToggleRecordingOnTap(sessionConfiguration: sessionConfiguration, animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
            .onRecognizeLatest(update: $output)
            .scaleEffect(0.7)
            .padding(.horizontal, -12)
//            .onChange
        }
        .onAppear {
            SwiftSpeech.requestSpeechRecognitionAuthorization()
        }
    }
}
//
//struct SwiftSpeechButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftSpeechButtonView()
//    }
//}
