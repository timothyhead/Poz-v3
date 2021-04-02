//
//  CustomizeJournalView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/24/21.
//

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
        VStack {
            BookStaticView(settings: settings, bookPatternIndex: $settings.journalPatternIndex)
                .padding(.vertical, 40 - CGFloat(patternIndex))
                
            Form {
                
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
        
    }
}
