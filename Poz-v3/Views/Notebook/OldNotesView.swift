//
//  OldNoteView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/26/21.
//

import SwiftUI
import Pages

struct OldNotesView: View {
    
    //get data from CoreData
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
    // for previus entry  pages
    @State var index: Int = 0
    @State var numberOfEntries = 0
    
    @State var date = Date()
    @State var dateFormatter = DateFormatter();
    @State var dateString: String = ""
    
    @State var selectedTag: Tag = Tag(name: "sss", color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)))
    @State var selected = ""
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        
        ZStack {
            
            ModelPages (
                notes, currentPage: $index,
                transitionStyle: .pageCurl,
                bounce: true
            ) { pageIndex, note  in
                
                VStack (alignment: .leading) {
                    
                    HStack {
                        Text(note.date ?? "1/1/1")
                            .font(Font.custom("Poppins-Bold", size: 16))
                            .foregroundColor(Color.primary)
                        
                        Spacer()
                        
                        //emoji putput
                        Text(note.emoji ?? "X")
                            .font(.system(size: 16))
                            .padding(.horizontal, 2)

                        HStack {
                            Text("\(selectedTag.name)")
                                .padding(.horizontal, 7)
                                .padding(.top, 4)
                                .padding(.bottom, 4)
                                .background(selectedTag.color)
                        }
                        .foregroundColor(Color.primary)
                        .cornerRadius(5)
                        
                    }
                    .onAppear() {
                        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
                        dateString = dateFormatter.string(from: date as Date)
                    }
                    
                    
                    
                    Divider()
                        .foregroundColor(Color.primary)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 3)
                    

                    Text (note.note ?? "Could not load note")
                        .font(Font.custom("Poppins-Regular", size: 16))
                        .padding(.top, 3)
                        .background(Color.clear)
                    
                    Spacer()
                    
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)
                .background(Color(UIColor(named: "NoteBG")!))
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }
        
        }
        .background(Color(UIColor(named: "NoteBG")!))
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        // set the previous entry pages index to last - 1 so its starts at the most recent entry
        .onAppear {
           DispatchQueue.main.async {
              self.index = notes.count - 1
           }
        }
    }
}


struct OldNotePageView: View {

    var body : some View {
        Text("hi")
    }
}
