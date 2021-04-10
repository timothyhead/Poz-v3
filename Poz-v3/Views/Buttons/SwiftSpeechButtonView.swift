import SwiftUI
import SwiftSpeech

//speech to text button - adapted from https://github.com/Cay-Zhang/SwiftSpeech

struct SwiftSpeechButtonView: View {
    
    var sessionConfiguration: SwiftSpeech.Session.Configuration
    
    @Binding var input: String
    @Binding var output: String
    
    public init(sessionConfiguration: SwiftSpeech.Session.Configuration, input: Binding<String>, output: Binding<String>) {
        self.sessionConfiguration = sessionConfiguration
        self._input = input
        self._output = output
    }
    public init(locale: Locale = .current, input: Binding<String>, output: Binding<String>) {
        self.init(sessionConfiguration: SwiftSpeech.Session.Configuration(locale: locale), input: input, output: output)
    }
    public init(localeIdentifier: String, input: Binding<String>, output: Binding<String>) {
        self.init(locale: Locale(identifier: localeIdentifier), input: input, output: output)
    }
    
    var body: some View {
        ZStack {
//            Text(output)
//                .offset(x: 40, y: -60)
        SwiftSpeech.RecordButton()
            .swiftSpeechToggleRecordingOnTap(sessionConfiguration: sessionConfiguration, animation: .spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
            .onRecognizeLatest(update: $output)
            .scaleEffect(0.7)
            .padding(.horizontal, -12)
//            .onChange
        }
        .onAppear {
            output = input
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
