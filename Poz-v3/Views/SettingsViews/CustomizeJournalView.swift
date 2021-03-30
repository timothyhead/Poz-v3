//
//  CustomizeJournalView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/24/21.
//

import SwiftUI

struct CustomizeJournalView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @State private var isEditing = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var index = 0
    
    @State var bookPatterns = bookPatternsList()
    
    var body: some View {
        VStack {
            BookStaticView(settings: settings)
            
            
            VStack {
                Text ("Color")
                Slider(
                    value: $settings.journalColorAngle,
                    in: 0...180,
                    onEditingChanged: { editing in
                        isEditing = editing
                        UserDefaults.standard.set(settings.journalColorAngle, forKey: "journalColorAngle")
                    }
                )
                
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach (bookPatterns.bookPatterns, id: \.self) { bookPattern in
                            Button (action: {
                                UserDefaults.standard.set(bookPattern.bookPatternIndex, forKey: "journalPatternIndex")
                                
                            }) {
                                Image(bookPattern.patternImageString)
                                    .resizable().frame(width:50, height: 50).clipShape(Circle())
                                
                            }
                        }
                    }
                }
                
                Text("Name")
                TextField("\(settings.journalName)", text: $settings.journalName) { isEditing in
                    self.isEditing = isEditing
                    UserDefaults.standard.set(settings.journalName, forKey: "journalName")
                }
                
                Text("Emoji")
                EmojiPicker(selectedIndex: $index, selected: $settings.journalEmoji)
            }
            .onChange(of: index) { value in
                UserDefaults.standard.set(settings.journalEmoji, forKey: "journalEmoji")
            }
            
            .padding()
            .padding(.top, 60)
        }
    }
}
