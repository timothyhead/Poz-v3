//
//  OldNoteView.swift
//  Poz-v3
//
//  Created by Kish Parikh on 3/26/21.
//

import SwiftUI
import Pages

class isInTransition: ObservableObject {
    @Published var inTransition: Bool = false
}

//struct OldNotesView: View {
    
//    @State var hidden = false
//    
//    
//    //get data from CoreData
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(
//        entity: Note.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)],
//        predicate:  NSPredicate(format: "prompt != %@", "Let it all out, don\'t hold back.")
//    ) var notes: FetchedResults<Note>
//    
//    // for previus entry  pages
//    @Binding var indexNotes: Int
//    @State var numberOfEntries = 0
//    
//    @State var date = Date()
//    @State var dateFormatter = DateFormatter();
//    @State var dateString: String = ""
//    
//    @State var selected = ""
//    @State private var selectedIndex: Int = 0
//    
//    @Binding var tabIndex: Int
//    
////    @State var inTransition: Bool = false
//    @StateObject var inTransition = isInTransition()
//    
////    @State var isEditing = false
//    
//    @State var tempText: String = "hello"
//    
//    var body: some View {
//        
//        ZStack {
//            
//            ModelPages (
//                
//                notes, currentPage: $indexNotes,
//                transitionStyle: .pageCurl,
//                bounce: true,
//                hasControl: false
//                
//            ) { pageIndex, note in
//                
//                VStack (alignment: .leading) {
//                    
//                    HStack (alignment: .center){
//                        Spacer()
//                        Text(note.date ?? " ")
//                            .font(Font.custom("Poppins-Bold", size: 16))
//                            .foregroundColor(Color.primary)
//                        Spacer()
//
//                    }.padding(.top, -5)
//                    
//                    Divider()
//                        .foregroundColor(Color.primary)
//                        .padding(.bottom, 3)
//                    
//                    ScrollView (.vertical){
//                        VStack (alignment: .leading){
//                            
//                            Text(note.emoji ?? "")
//                                .font(Font.custom("Poppins-Regular", size: 48))
//                                .padding(.bottom, -9)
//                            
//                            if ((note.prompt != "") && (note.prompt != nil)) {
//                                Text(note.prompt ?? "")
//                                    .font(Font.custom("Poppins-Medium", size: 16))
//                                    .padding(.top, 10)
//                                    .padding(.bottom, 6)
//                            }
//                            
//                            Text (note.note ?? "")
//                                .font(Font.custom("Poppins-Regular", size: 16))
//                            
////                            Text("\(indexNotes)")
//                        }
//                    }
//                    .padding(.top, -11)
//                    Spacer()
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 60)
//                .background(Color(UIColor(named: "NoteBG")!))
//                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//            }
//        
//        }
//        .background(Color(UIColor(named: "NoteBG")!))
//        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//        // set the previous entry pages index to last - 1 so its starts at the most recent entry
//        .onAppear {
//            if (notes.count > 0) {
//               DispatchQueue.main.async {
//                  self.indexNotes = notes.count - 1
//               }
//            }
//        }
//    }
//}


struct OldNotePageView: View {

    var body : some View {
        Text("hi")
    }
}


//expirement with text field on each previous note
struct NoteText : View {
    
    @State var TextEditorIsShowing: Bool = false
    @Binding var text: String
    
//    @Binding var inTransition: Bool
    @EnvironmentObject var inTransition: isInTransition
    
    var body : some View {
        
        ZStack {
            if inTransition.inTransition == false {
                
                TextEditor(text: $text)
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .padding(.top, 20)
                    .onAppear {
                        print("textEditor appeared")
                    }
                    .onDisappear {
                        print("textEditor DISappeared")
                        
                        TextEditorIsShowing = true
                    }
                    
                
            } else if inTransition.inTransition == true {
                
                Text (text)
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .padding(.top, 3)
                    .background(Color.clear)
                    .onAppear {
                        print("text appeared")
//                                    TextEditorIsShowing = false
                    }
                    .onDisappear {
                        print("text DISappeared")
                        TextEditorIsShowing = false
                    }
                    
                
            }
        }
    }
}
