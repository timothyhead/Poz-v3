import SwiftUI

var Categories: [Category] = []
var lastIndex: Int = 0

struct Category: Hashable {
    let id: Int
    var emoji: String
    var selected: Bool

    init (id: Int, emoji: String, selected: Bool) {
        self.id = id
        self.emoji = emoji
        self.selected = selected
    }
}

struct EmojiPicker: View {
    
    @Binding var selectedIndex: Int
    @Binding var selected : String
    @State private var currentIndex: Int = 0
    @Namespace private var ns
    
    //add all the emojis
    init(selectedIndex: Binding<Int>, selected: Binding<String>) {
        _selectedIndex = selectedIndex
        _selected = selected
        Categories.removeAll()
        Categories.append(Category(id: 0, emoji: "✖️", selected: true))
        Categories.append(Category(id: 1, emoji: "🤩", selected: false))
        Categories.append(Category(id: 2, emoji: "🥳", selected: false))
        Categories.append(Category(id: 3, emoji: "😎", selected: false))
        Categories.append(Category(id: 4, emoji: "😍", selected: false))
        Categories.append(Category(id: 5, emoji: "😇", selected: false))
        Categories.append(Category(id: 6, emoji: "🥸", selected: false))
        Categories.append(Category(id: 7, emoji: "🤯", selected: false))
        Categories.append(Category(id: 8, emoji: "🤠", selected: false))
        Categories.append(Category(id: 9, emoji: "😂", selected: false))
        Categories.append(Category(id: 10, emoji: "🙄", selected: false))
        Categories.append(Category(id: 11, emoji: "🤠", selected: false))
        Categories.append(Category(id: 12, emoji: "😂", selected: false))
        Categories.append(Category(id: 13, emoji: "😝", selected: false))
        Categories.append(Category(id: 14, emoji: "🥲", selected: false))
        Categories.append(Category(id: 15, emoji: "😊", selected: false))
        Categories.append(Category(id: 16, emoji: "☺️", selected: false))
        Categories.append(Category(id: 17, emoji: "😌", selected: false))
        Categories.append(Category(id: 18, emoji: "🙃", selected: false))
        Categories.append(Category(id: 19, emoji: "🙂", selected: false))
        Categories.append(Category(id: 20, emoji: "😬", selected: false))
        Categories.append(Category(id: 21, emoji: "😐", selected: false))
        Categories.append(Category(id: 22, emoji: "😕", selected: false))
        Categories.append(Category(id: 23, emoji: "🙁", selected: false))
        Categories.append(Category(id: 24, emoji: "☹️", selected: false))
        Categories.append(Category(id: 25, emoji: "😟", selected: false))
        Categories.append(Category(id: 26, emoji: "🤒", selected: false))
        Categories.append(Category(id: 27, emoji: "😧", selected: false))
        Categories.append(Category(id: 28, emoji: "🤒", selected: false))
        Categories.append(Category(id: 29, emoji: "🥴", selected: false))
        Categories.append(Category(id: 30, emoji: "😩", selected: false))
        Categories.append(Category(id: 31, emoji: "😭", selected: false))
        Categories.append(Category(id: 32, emoji: "😓", selected: false))
        Categories.append(Category(id: 33, emoji: "🙄", selected: false))
        Categories.append(Category(id: 34, emoji: "😳", selected: false))
        Categories.append(Category(id: 35, emoji: "😵", selected: false))
        Categories.append(Category(id: 36, emoji: "🤔", selected: false))
        Categories.append(Category(id: 37, emoji: "🥱", selected: false))
        Categories.append(Category(id: 38, emoji: "🤢", selected: false))
        Categories.append(Category(id: 39, emoji: "😤", selected: false))
        Categories.append(Category(id: 40, emoji: "🥵", selected: false))
        Categories.append(Category(id: 41, emoji: "🤬", selected: false))
    }

    
    var body: some View {
        VStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollView in
                    HStack(spacing: 35) {
                        ForEach(Categories, id: \.self) { item in
                            if item.id == currentIndex {
                                ZStack() {
                                    Text(item.emoji)
                                        .font(.system(size: 70))
                                        .bold()
                                        .layoutPriority(1)
                                        .scaleEffect(1.1)
                                        .foregroundColor(.black )
                                    VStack() {
                                        Rectangle().frame(height: 30)
                                            .padding(.top, 100)
                                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8470588235)))
                                            .opacity(0.0)
                                        
                                    }
                                    .matchedGeometryEffect(id: "animation", in: ns)
                                }
                            } else {
                                Text(item.emoji)
                                    .onTapGesture {
                                        withAnimation {
                                            currentIndex = item.id
                                            selectedIndex = currentIndex
                                            
                                            
                                            if (item.emoji == "✖️") {
                                                selected = ""
                                            } else {
                                                selected = item.emoji
                                            }
                                            
                                            scrollView.scrollTo(item)
                                        }
                                        
                                    }
                                    .opacity(0.4)
                                    .scaleEffect(1.0)
                                    .font(.system(size: 70))
                            }
                        }
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 20)
                }
            }
        }
    }
}
