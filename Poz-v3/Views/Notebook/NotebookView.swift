//
//  NotebookView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/26/21.
//

import SwiftUI
import Pages

struct NotebookView: View {

    @Binding var tabIndex: Int

    @State var indexNotes: Int = UserDefaults.standard.integer(forKey: "LastPageOpen")
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt,ascending: true)]
    ) var notes: FetchedResults<Note>

    @Binding var promptSelectedIndex: Int
    
    
    @State var showPageSlider = false
    @State var isEditing = true
    @State var pageNumber = 0.0
    
    
    var body: some View {
        
        ZStack {
                   
//            NoteTopMenuView(settings: settings, tabIndex: $tabIndex)
            
            ModelPages (

                notes, currentPage: $indexNotes,
                transitionStyle: .pageCurl,
                bounce: true,
                hasControl: false

            ) { pageIndex, note in
                
                NotePage(settings: settings, note: note, promptSelectedIndex: $promptSelectedIndex, tabIndex: $tabIndex, showPageSlider: $showPageSlider).environment(\.managedObjectContext, self.moc)
                    .onDisappear () {
                        UserDefaults.standard.set(indexNotes, forKey: "LastPageOpen")
                    }
            }
            .padding(.top, -6)
            
            if showPageSlider {
                
                ZStack {
                    
                    if (isEditing || showPageSlider) {
                        Text("Turn to page \(Int(pageNumber))")
                            .font(Font.custom("Poppins-Regular", size: 16))
                            .offset(x: 50, y: 45)
                    }
                
                    Slider(
                        value: $pageNumber,
                        in: 0...Double(notes.count - 1),
                        onEditingChanged: { editing in
                            isEditing = editing
                            indexNotes = Int(pageNumber)
                            if !isEditing {
                                showPageSlider = false
                            }
                        }
                    )
                }
                .background(Color(UIColor(named: "NoteBG")!))
                .offset(y: (UIScreen.main.bounds.height/2 - 100))
                .padding()
                
            }
        }
    }
}
