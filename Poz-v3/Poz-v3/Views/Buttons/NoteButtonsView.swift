import SwiftUI
import SwiftSpeech

// buttons vertically arranged for popover, not in use

struct NoteButtonsVerticalView: View {

    //audio to text
    @State private var emojiPickerShowing: Bool = false;
    @State private var addPhotoShowing: Bool = false;
    @State private var addSpecialShowing: Bool = false;
    
    @Binding var buttonSpacing: CGFloat
    
    var body: some View {
        
        //emoji picker
        if (emojiPickerShowing == true) {
            Text("Scroll below to tag entry with emoji")
                .padding(.top, 30)
                .foregroundColor(.gray)
//            EmojiPicker(selectedIndex: $selectedIndex, selected: self.$selected)
        }
        
        
        // Special Buttons
        VStack(spacing: buttonSpacing) {
            
            Spacer()
            
            //emoji button
            Button(action: { emojiPickerShowing.toggle()}) {
                ZStack{
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
                    Text(emojiPickerShowing ? "😏" : "😶")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
            }
            .scaleEffect((emojiPickerShowing ? 1.76 : 1))
            
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1490374432)), radius: 5)
            
//            SwiftSpeechButtonView(output )
            
            // photo button
            Button(action: {
                    addPhotoShowing.toggle()
//                    self.show.toggle()
            }) {
                ZStack{
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)))
                    Image(systemName: (addPhotoShowing ? "photo.on.rectangle.angled" : "photo.on.rectangle")).resizable()
                        .frame(width: 20, height: 17)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
            .scaleEffect((addPhotoShowing ? 1.76 : 1))
            .animation(.easeOut(duration: 0.2))
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1490374432)), radius: 5)
//            .sheet(isPresented: self.$show) {
//                ImagePicker(show: self.$show, image: self.$image)
//            }
            
            //sparkles button
            Button(action: { addSpecialShowing.toggle() }) {
                ZStack{
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)))
                    Image(systemName: (addSpecialShowing ? "sparkles" : "sparkle")).resizable()
                        .frame(width: 20, height: 20)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
            .scaleEffect((addSpecialShowing ? 1.76 : 1))
            .animation(.easeOut(duration: 0.2))
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1490374432)), radius: 5)
            
            
            
        }
        .animation(.easeOut(duration: 0.2))
    }
}

//struct NoteButtonsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteButtonsView()
//    }
//}
