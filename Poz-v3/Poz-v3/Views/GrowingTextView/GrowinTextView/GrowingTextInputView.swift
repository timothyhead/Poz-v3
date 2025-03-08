import SwiftUI

struct GrowingTextInputView: View {
  init(text: Binding<String?>, placeholder: String?, focused: Binding<Bool>) {
    self._text = text
      _focused = focused
    self.placeholder = placeholder
  }

  @Binding var text: String?
    @Binding var focused: Bool
  @State var contentHeight: CGFloat = 0

  let placeholder: String?
  let minHeight: CGFloat = UIScreen.main.bounds.height
  let maxHeight: CGFloat = UIScreen.main.bounds.height*5

  var countedHeight: CGFloat {
    min(max(minHeight, contentHeight), maxHeight)
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
//      Color.white
      ZStack(alignment: .topLeading) {
        placeholderView
        TextViewWrapper(text: $text, focused: $focused, contentHeight: $contentHeight)
      }
    }
    .frame(height: countedHeight)
  }

  var placeholderView: some View {
    ViewBuilder.buildIf(
      showPlaceholder ?
        placeholder.map {
          Text($0)
            .foregroundColor(.gray)
            .font(Font.custom("Poppins-Regular", size: 16))
            .offset(x: 4, y: 6)
        } : nil
    )
  }

  var showPlaceholder: Bool {
    !focused && text.orEmpty.isEmpty == true
  }
}

#if DEBUG
struct GrowingTextInputView_Previews: PreviewProvider {
  @State static var text: String?

  static var previews: some View {
    GrowingTextInputView(
      text: $text,
      placeholder: "Placeholder", focused: .constant(false)
    )
  }
}
#endif
