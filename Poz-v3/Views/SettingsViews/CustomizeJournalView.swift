import SwiftUI

struct CustomizeJournalView: View {
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isEditing = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var index = 0
    
    @State var bookPatterns = bookPatternsList()
    
    @State var patternIndex = 0
    
    var body: some View {
        VStack (alignment: .center) {
            
           BookStaticView(settings: settings, bookPatternIndex: $settings.journalPatternIndex)
                .padding(.vertical, 40 - CGFloat(patternIndex))
                
            Form {
                
                Section(header: Text("Edit Journal Name")) {
                    TextField("\(settings.journalName)", text: $settings.journalName) { isEditing in
                        self.isEditing = isEditing
                        UserDefaults.standard.set(settings.journalName, forKey: "journalName")
                    }
                    .font(Font.custom("Poppins-Light", size: 16))
                }
                
                Section(header: Text("Emoji")) {
                    EmojiPickerB(selectedIndex: $index, selected: $settings.journalEmoji)
                        .padding(.horizontal, -20)
                }
                
                Section(header: Text("Color")) {
                    Slider(
                        value: $settings.journalColorAngle,
                        in: 0...180,
                        onEditingChanged: { editing in
                            isEditing = editing
                            UserDefaults.standard.set(settings.journalColorAngle, forKey: "journalColorAngle")
                        }
                    )
                }
                
                Section(header: Text("Pattern")) {
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach (bookPatterns.bookPatterns, id: \.self) { bookPattern in
                                Button (action: {
                                    
                                    settings.journalPatternIndex = bookPattern.bookPatternIndex
                                    UserDefaults.standard.set(settings.journalPatternIndex, forKey: "journalPatternIndex")
                                    
                                }) {
                                    if colorScheme == .dark {
                                    Image(bookPattern.patternImageString)
                                        .resizable().frame(width:50, height: 50).clipShape(Circle())
                                        .colorInvert()
                                    } else{
                                        Image(bookPattern.patternImageString)
                                            .resizable().frame(width:50, height: 50).clipShape(Circle())
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, -20)
                }
            }
            .navigationTitle("Customize journal 📔")
            .onChange(of: index) { value in
                UserDefaults.standard.set(settings.journalEmoji, forKey: "journalEmoji")
            }
        }
    }
}


struct CustomizeJournalViewOnboard: View {
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isEditing = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var index = 0
    
    @State var bookPatterns = bookPatternsList()
    
    @State var patternIndex = 0
    
    var body: some View {
        VStack (alignment: .center) {
            VStack {
                Text("This is your journal")
                        .font(Font.custom("Blueberry", size: 28))
                        .foregroundColor(.primary)
                Text("Customize it as you like!")
                        .font(Font.custom("Poppins-Light", size: 18))
                        .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
                
                HStack (alignment: .center) {
                    Spacer()
                    BookStaticView(settings: settings, bookPatternIndex: $settings.journalPatternIndex)
                        .scaleEffect(0.8)
                    Spacer()
               }
                
            }
            .multilineTextAlignment(.center)
            .padding()
            
            Form {
                
               
//
                
                Section(header: Text("Edit Name")) {
                    TextField("\(settings.journalName)", text: $settings.journalName) { isEditing in
                        self.isEditing = isEditing
                        UserDefaults.standard.set(settings.journalName, forKey: "journalName")
                    }
                    .font(Font.custom("Poppins-Light", size: 16))
                }
                
                Section(header: Text("Emoji")) {
                    EmojiPickerB(selectedIndex: $index, selected: $settings.journalEmoji)
                        .padding(.horizontal, -20)
                }
                
                Section(header: Text("Color")) {
                    Slider(
                        value: $settings.journalColorAngle,
                        in: 0...180,
                        onEditingChanged: { editing in
                            isEditing = editing
                            UserDefaults.standard.set(settings.journalColorAngle, forKey: "journalColorAngle")
                        }
                    )
                }
                
                Section(header: Text("Pattern")) {
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach (bookPatterns.bookPatterns, id: \.self) { bookPattern in
                                Button (action: {
                                    
                                    settings.journalPatternIndex = bookPattern.bookPatternIndex
                                    UserDefaults.standard.set(settings.journalPatternIndex, forKey: "journalPatternIndex")
                                    
                                }) {
                                    if colorScheme == .dark {
                                    Image(bookPattern.patternImageString)
                                        .resizable().frame(width:50, height: 50).clipShape(Circle())
                                        .colorInvert()
                                    } else{
                                        Image(bookPattern.patternImageString)
                                            .resizable().frame(width:50, height: 50).clipShape(Circle())
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, -20)
                }
            }
            .onChange(of: index) { value in
                UserDefaults.standard.set(settings.journalEmoji, forKey: "journalEmoji")
            }
            
        }
        .padding(.top, 80)
        .multilineTextAlignment(.center)
    }
}
