import SwiftUI

struct OnboardingWelcome: View {
    
    @State var index = 0
    @ObservedObject var settings: SettingsModel
    @State var message: String?
    @Binding var tabIndex: Int
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        VStack (spacing: 0) {
            
            Text("Welcome to Poz")
                .font(Font.custom("Blueberry", size: 36))
                .foregroundColor(.primary)
                
            
            Text("Your personal mindfulness journal")
                .font(Font.custom("Poppins-Light", size: 18))
                .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
            
            Image("Alone").resizable().frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 30)
            
        }
        .background((Color(UIColor(named: "HomeBG")!)))
        
    }
}
