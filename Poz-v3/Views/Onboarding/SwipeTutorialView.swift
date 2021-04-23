import SwiftUI

// simple view that shows the first time the notebook is opened
struct SwipeTutorialView: View {
    @State var show = true
    
    var body: some View {
        
        if show {
            ZStack {
                Image (systemName: "xmark")
                    .foregroundColor(.white)
                    .offset(x: -80, y: -75)
                
                VStack {
                    
                    // lottie animation from Jed Nocum - https://lottiefiles.com/17651-swipe-left-to-right
                    LottieView(fileName: "swipe-simple")
                        .frame(width: 150, height: 100)
                    Text("Swipe to turn pages")
                        .foregroundColor(.white)
                        .font(Font.custom("Poppins-Light", size: 14))
                    
                }
            }
            .padding(.all, 40)
            .background(Color.black.opacity(0.85))
            .frame(width: 200, height: 190, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .cornerRadius(10)
        }
    }
}

//struct SwipeTutorialView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SwipeTutorialView()
//    }
//}
