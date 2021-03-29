//
//  NoteTopMenuView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/26/21.
//

import SwiftUI

struct NoteTopMenuView: View {
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var tabIndex: Int
    
    @State var prevPostsShowing = false
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    
    var body: some View {
        HStack {
            
            if notes.count > 2 {
                Button (action:{ prevPostsShowing.toggle() }) {
                    ZStack {
                        Text("🔍")
//                        Image(systemName: "clock.arrow.circlepath")
                            .font(Font.custom("Poppins-Light", size: 20))
                            .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.9333333333, alpha: 1)) : Color(#colorLiteral(red: 0.1514667571, green: 0.158391118, blue: 0.1616251171, alpha: 1)))
                    }.frame(width: 40, height: 40)
                }
                .sheet(isPresented: $prevPostsShowing, content: {
                        NotesListView(settings: settings).environment(\.managedObjectContext, self.moc)
                })
            }
        
            Spacer()
            

            // home button
            Button (action: {
                
                withAnimation(.spring()) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.15) {
//                    isAnimating = true
                    }
                    
                    withAnimation () {
                        tabIndex = 0
                    }
                }
                
            }) {
                ZStack {
                    Text("✖️")
//                    Image(systemName: ("xmark")).resizable()
//                        .frame(width: 20, height: 20)
                        .font(Font.custom("Poppins-Light", size: 26))
                        .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.9333333333, alpha: 1)) : Color(#colorLiteral(red: 0.1514667571, green: 0.158391118, blue: 0.1616251171, alpha: 1)))
                }.frame(width: 40, height: 40)
            }
            
        }
    }
}
