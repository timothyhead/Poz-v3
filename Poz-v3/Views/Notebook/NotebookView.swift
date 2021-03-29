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
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    var body: some View {
        
        ZStack {

            //  highest level page system to old old entry pages and add entry
            Pages (
                
                currentPage: $indexAdd,
                transitionStyle: .pageCurl,
                hasControl: false
                
            ) {
                
                //page system of all previously entered notes
                OldNotesView(tabIndex: $tabIndex).environment(\.managedObjectContext, self.moc)

                //new note page, passes in new note object
                addNoteView(tabIndex: $tabIndex, note: Note(context: self.moc)).environment(\.managedObjectContext, self.moc)

            }

            VStack {
                NoteTopMenuView(settings: settings, tabIndex: $tabIndex).environment(\.managedObjectContext, self.moc)
                    .padding(.horizontal, 20)
                    .padding(.top, 50)
                
                Spacer()
            }
            
        }
    }
}
