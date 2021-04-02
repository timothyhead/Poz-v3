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
    @Binding var indexAdd: Int
    
    @State var indexNotes = 0
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt,ascending: true)]
//        predicate:  NSPredicate(format: "emoji != %@", "")
    
    ) var notes: FetchedResults<Note>

    @Binding var promptSelectedIndex: Int
    
    @State var showing = true
    
    @State private var message: String?
    @State private var emoji: String = ""
    
    var body: some View {
        
        ZStack {
            if showing {
                    
                //  highest level page system to old old entry pages and add entry
                
                
                // -----
                
//                Pages (
//
//                    currentPage: $indexAdd,
//                    transitionStyle: .pageCurl,
//                    hasControl: false
//
//                ) {
//
//                    //page system of all previously entered notes
//                    OldNotesView(indexNotes: $indexNotes, tabIndex: $tabIndex).environment(\.managedObjectContext, self.moc)
//
//                    addNoteView(tabIndex: $tabIndex, indexNotes: $indexNotes, showing: $showing, note: Note(context: self.moc), promptSelectedIndex: $promptSelectedIndex)
//
//
                    
                //  --------
                    
                    
                    
                ModelPages (

                    notes, currentPage: $indexAdd,
                    transitionStyle: .pageCurl,
                    bounce: true,
                    hasControl: true

                ) { pageIndex, note in

//                    ForEach (notes, id: \.self) { note in
                    newAddNote(settings: settings, note: note, promptSelectedIndex: $promptSelectedIndex).environment(\.managedObjectContext, self.moc)

//                VStack {
//                    NoteTopMenuView(settings: settings, tabIndex: $tabIndex).environment(\.managedObjectContext, self.moc)
//                        .padding(.horizontal, 20)
//                        .padding(.top, 50)
//
//                    Spacer()
//                }
                    
                    // body content
//                    VStack (alignment: .leading) {
//
//                        //show emoji
//                        Text(note.emoji ?? "X")
//                            .font(Font.custom("Poppins-Regular", size: 48))
//                            .padding(.bottom, -20)
//
//                        //text input
//                        GrowingTextInputView(text: $message, placeholder: "Tap here to begin typing")
//                            .font(Font.custom("Poppins-Regular", size: 16))
//                            .padding(.top, 8)
//                            .onAppear() {
////                                print(note.note ?? "empty")
//                                message = note.note
//                            }
//
//                    }
//                    .padding(.horizontal, 20)
//                    .onChange(of: message) { value in
//                        if (message != "") {
////                            saveNoteB()
////                            note.note = message
//                        }
//                    }
                }
            }
            
        }
        
    }
    
    
}
