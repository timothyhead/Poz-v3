import SwiftUI

struct NotesListView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Note.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: false)]
    ) var notes: FetchedResults<Note>
    
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
        
            VStack {
                ZStack (alignment: .topLeading) {
                    
                    SearchView(searchText: $text)
                    
                    if text.isEmpty {
                        Text("Search previous entries")
                            .foregroundColor(.gray)
                            .padding(.top, 18)
                            .padding(.leading, 38)
                    }
                }
                .padding(.top, -10)
                .padding(.horizontal, 20)
            }
            
            List {
                ForEach (notes, id: \.id) { notes in // .filter{ text == "" ? true : $0.note!.localizedCaseInsensitiveContains(text)}
                    
                    if ((notes.note) != nil) && ((notes.note) != "") {
                        HStack (alignment: .top) {
                            Text(notes.emoji ?? "")
                                .font(.system(size: 48))
                            VStack (alignment: .leading) {
                                Text(notes.date ?? " ")
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(.bottom, -3)
                                Text(notes.note ?? "This is an empty post.")
                                    .font(.system(size: 20))
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

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        NotesListView()
    }
}
