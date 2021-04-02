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
    
    @State var showing = true
    
    var body: some View {
        
        ZStack {
            if showing {
                    
                ModelPages (

                    notes, currentPage: $indexNotes,
                    transitionStyle: .pageCurl,
                    bounce: true,
                    hasControl: true

                ) { pageIndex, note in
                    
                    NotePage(settings: settings, note: note, promptSelectedIndex: $promptSelectedIndex).environment(\.managedObjectContext, self.moc)
                        .onDisappear () {
                            UserDefaults.standard.set(indexNotes, forKey: "LastPageOpen")
                        }
                }
            }
        }
    }
}
