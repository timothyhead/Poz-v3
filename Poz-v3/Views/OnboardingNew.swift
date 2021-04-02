import SwiftUI
import Pages

struct OnboardingNew: View {
    
    @State var index = 0
    @ObservedObject var settings: SettingsModel
    @State var message: String?
    @Binding var tabIndex: Int
    
    var body: some View {
        Pages (

            currentPage: $index,
            transitionStyle: .pageCurl

        ) {
            
            VStack {
                Text("Welcome to Poz")
                Text("Swipe left to turn the page")
            }
            .frame(width: 400, height: 900).background(Color.blue)
            
            
            VStack {
                Text("This is your journal")
                Text("Fully customizable, and the home for all your notes")
            }
            .frame(width: 400, height: 900).background(Color.orange)
            
            VStack {
                Text("These are entries, work just like a journal")
                Text("Swipe right to get into the app")
                
                Button (action: { tabIndex = 0 }) {
                    Text("get into the app")
                }
            }
            .frame(width: 400, height: 900).background(Color.yellow)
            
            
//            @State private var message: String?
//
        }
    }
}
