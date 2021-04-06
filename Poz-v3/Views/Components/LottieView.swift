import SwiftUI
import Lottie

// lottie book file from https://lottiefiles.com/38292-full-book

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    
    var fileName: String
//    @Binding var animationInProgress: Bool
    @Binding var isPaused: Bool
    @Binding var stopAnim: Bool
    
    @State var startFrame: CGFloat = 55
    @State var endFrame: CGFloat = 200
    
    let view = UIView(frame: .zero)
    let animationView = AnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {

        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
//        animationView.play(fromFrame: endFrame, toFrame: startFrame, loopMode: .none) { complete in
//
//        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        if isPaused && !stopAnim {
            context.coordinator.parent.animationView.play(fromFrame: endFrame, toFrame: startFrame)
        } else if (isPaused == false) {
            context.coordinator.parent.animationView.play(fromFrame: startFrame, toFrame: endFrame)

        }
    }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject {
            var parent: LottieView

            init(_ parent: LottieView) {
                self.parent = parent
            }
        }
    
    func openBook() {
        animationView.play()
        
//        NSLayoutConstraint.activate([
//            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2)
//        ])
        
    }
    
    func closeBook() {
        
        
    }
    
}
