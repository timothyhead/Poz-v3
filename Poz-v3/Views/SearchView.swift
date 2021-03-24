import SwiftUI

// code from https://www.youtube.com/watch?v=TOUD5Rm6GS0
// adapted to work with core data

struct SearchView: UIViewRepresentable {
    
    @Binding var searchText : String
    
    func makeCoordinator() -> SearchView.Coordinator {
        return SearchView.Coordinator(parent1: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchView>) -> UISearchBar {
        
        let SearchBar = UISearchBar()
        SearchBar.barStyle = .default
        SearchBar.autocapitalizationType = .none
        SearchBar.delegate = context.coordinator
        return SearchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchView>) {
        
    }
    
    class Coordinator : NSObject, UISearchBarDelegate  {
        var parent : SearchView!
        
        init (parent1: SearchView) {
            parent = parent1
        }
        
        func searchBar(_ SearchBar: UISearchBar, textDidChange searchText: String) {
            
            parent.searchText = searchText
            
        }
    }
}

