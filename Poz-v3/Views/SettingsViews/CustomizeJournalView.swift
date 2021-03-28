//
//  CustomizeJournalView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/24/21.
//

import SwiftUI

struct CustomizeJournalView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @State var hueRotateAngle: Double = 0
    @State private var isEditing = false
    
    @State var index = 0
    
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
                    }
                )
                
                Text("Name")
                TextField("\(settings.journalName)", text: $settings.journalName) { isEditing in
                    self.isEditing = isEditing
                }
                
                Text("Emoji")
                EmojiPicker(selectedIndex: $index, selected: $settings.journalEmoji)
                
            }
            .padding()
            .padding(.top, 60)
        }
    }
}
