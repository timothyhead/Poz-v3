import SwiftUI
import CoreData

// list of notes

struct NotesListView: View {
    
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var settings: SettingsModel
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)],
        predicate:  NSPredicate(format: "note != %@", "")
    ) var notes: FetchedResults<Note>
    
    let sort = NSSortDescriptor(key: "name", ascending: true)
    
    //filtering
    @State var text = ""
    
    @State var showingAlert = false
    
    var body: some View {
        
        //list of all notes
        VStack {
            
            Capsule()
                .frame(width: 100, height: 8)
                .padding(.top, 10)
                .foregroundColor(.gray)
                .padding(.bottom, 15)
        
//            VStack {
//                ZStack (alignment: .topLeading) {
//
//                    SearchView(searchText: $text)
//
//                    if text.isEmpty {
//                        Text("Search previous entries")
//                            .foregroundColor(.gray)
//                            .padding(.top, 18)
//                            .padding(.leading, 38)
//                    }
//                }
//                .padding(.top, -10)
//                .padding(.horizontal, 20)
//            }
            //.filter{ text == "" ? true : $0.note!.localizedCaseInsensitiveContains(text)}
            // https://www.youtube.com/watch?v=oK1K5h5EbZY
            List {
                ForEach (notes, id: \.id) { note in
                    
                    if ((note.note) != nil) && ((note.note) != "") && (note.note != settings.welcomeText) && (note.note != "...") {
                        HStack (alignment: .top) {
                            Text(note.emoji ?? "")
                                .font(.system(size: 48))
                            VStack (alignment: .leading) {
                                Text(note.date ?? " ")
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(.bottom, -3)
                                Text(note.note ?? "This is an empty post.")
                                    .font(.system(size: 20))
                            }
                        }
                        .onAppear() {
                            if filterList(note: note) {
                                print("is true")
                            }
                        }
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                    }
                }
                
//                .onDelete(perform: removeItem)
//                .alert(isPresented: $showingAlert) {
//                    Alert(title: Text("Can't delete"), message: Text("You must have 2 notes minimum. Add more notes to delete this one"), dismissButton: .default(Text("Got it!")))
//                }
            }
            .padding(.top, -8)
            .padding(.bottom, -8)

        }
    }
    
//    func getNotes (with name: String) -> Note? {
//        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "%K == %@",
//                                             argumentArray: ["name", name])
//        
//        return try? persistentContainer.viewContext.fetch(fetchRequest).first
////        do {
////            return try persistentContainer.viewContext.fetch(fetchRequest).first
////        } catch let error {
////            print("\(error)")
////            return nil
////        }
//    }
    
    func filterList (note: Note) -> Bool {
//       filterList
//        let hello = note.note

        print (note.note ?? "note text")
        print(NSString(string: note.note!).localizedCaseInsensitiveContains(""))
        
        return NSString(string: note.note!).localizedCaseInsensitiveContains("")
//
    }
    
    // delete function
    func removeItem(at offsets: IndexSet) {
        
        if notes.count > 2 {
            for index in offsets {
                let note = notes[index]
                moc.delete(note)
            }
            
            do {
                try self.moc.save()
            } catch {
            }
        } else {
            showingAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showingAlert = false
            }
        }
    }
}
