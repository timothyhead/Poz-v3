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
    
    @Binding var tabIndex: Int
    
//    @State var inTransition: Bool = false
    @StateObject var inTransition = isInTransition()
    
    @State var tempText: String?
    
    var body: some View {
        
        ZStack {
            
            ModelPages (
                notes, currentPage: $index,
                transitionStyle: .pageCurl,
                bounce: true,
                hasControl: false
                
            ) { pageIndex, note  in
                
                VStack (alignment: .leading) {
                    
                    NoteTopMenuView(tabIndex: $tabIndex)
                    
                    HStack (alignment: .center){
                        Spacer()
                        Text(note.date ?? "1/1/1")
                            .font(Font.custom("Poppins-Bold", size: 16))
                            .foregroundColor(Color.primary)
//
                        Spacer()
//                        Spacer()
//
//                        //emoji putput
//                        Text(note.emoji ?? "X")
//                            .font(.system(size: 16))
//                            .padding(.horizontal, 2)
//
//                        HStack {
//                            Text("\(selectedTag.name)")
//                                .padding(.horizontal, 7)
//                                .padding(.top, 4)
////                                .padding(.bottom, 4)
//                                .background(selectedTag.color)
//                        }
//                        .foregroundColor(Color.primary)
//                        .cornerRadius(5)
                        
                    }.padding(.vertical, -30)
                    .onAppear() {
                        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a"
                        dateString = dateFormatter.string(from: date as Date)
                    }
                    
                    
                    
                    Divider()
                        .foregroundColor(Color.primary)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 3)
                    

                    Text (note.note ?? "Empty")
//                    GrowingTextInputView(text: $tempText, placeholder: "Message")
//
//                    NoteText(text: $tempText).environmentObject(inTransition)
//                        .onAppear {
//                            tempText = note.note ?? "Empty"
//
//                            print(" appeared")
////                            inTransition.inTransition = true
//                        }
//                        .onDisappear {
//                            print(" DISappeared")
//                            inTransition.inTransition = false
//                        }

                    
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


struct NoteText : View {
    
    @State var TextEditorIsShowing: Bool = false
    @Binding var text: String
    
//    @Binding var inTransition: Bool
    @EnvironmentObject var inTransition: isInTransition
    
    var body : some View {
        
        ZStack {
//            if inTransition.inTransition == false {
                
                TextEditor(text: $text)
                    .font(Font.custom("Poppins-Regular", size: 16))
                    .padding(.top, 20)
//                        .background(Color.clear)
//                        .frame(maxHeight: .infinity)
//                    .onAppear () {
//                        text = note.note ?? "Empty"
//                    }
                    .onAppear {
                        print("textEditor appeared")
//                                    TextEditorIsShowing = false
                    }
                    .onDisappear {
                        print("textEditor DISappeared")
                        
                        TextEditorIsShowing = true
                    }
                    
                
//            } else if inTransition.inTransition == true {
                
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
                    
                
//            }
        }
    }
}
