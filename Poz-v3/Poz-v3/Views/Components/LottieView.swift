import SwiftUI
import Lottie

// displays a lottie animation!

// swipe animation from https://lottiefiles.com/17651-swipe-left-to-right
// lottie book file from https://lottiefiles.com/38292-full-book

struct LottieView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    
    var fileName: String
    
    let view = UIView(frame: .zero)
    let animationView = AnimationView()
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {

        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        animationView.play()
        animationView.loopMode = .loop
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
}
