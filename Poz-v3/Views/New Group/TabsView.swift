import SwiftUI

// a standard bottom tab navigation, not in use atm

struct TabsView: View {
    
    @Binding var index: Int
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {

            Rectangle().frame(width: UIScreen.main.bounds.width, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)))
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05120627296))]), startPoint: .top, endPoint: .bottom))
                .padding(.top, -17)
            HStack {
                Button(action: {self.index = 0}) {
                    Image(systemName: (self.index == 0 ? "house.fill" : "house")).resizable()
                    .frame(width: 25, height: 25)
                    .opacity((self.index == 0 ? 1 : 0.3))
                    .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.9333333333, alpha: 1)) : Color(#colorLiteral(red: 0.1514667571, green: 0.158391118, blue: 0.1616251171, alpha: 1)))
                }
                
                Spacer()
                
                Button(action: {self.index = 1}) {
                    Image(systemName: (self.index == 1 ? "book.fill" : "book")).resizable()
                        .frame(width: 25, height: 25)
                        .opacity((self.index == 1 ? 1 : 0.3))
                        .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.9333333333, alpha: 1)) : Color(#colorLiteral(red: 0.1514667571, green: 0.158391118, blue: 0.1616251171, alpha: 1)))
                }
                
                Spacer()

                Button(action: {self.index = 2}) {
                    Image(systemName: (self.index == 2 ? "dpad.fill" : "dpad")).resizable()
                        .frame(width: 25, height: 25)
                        .opacity((self.index == 2 ? 1 : 0.3))
                        .foregroundColor(colorScheme == .dark ? Color(#colorLiteral(red: 0.9254901961, green: 0.9294117647, blue: 0.9333333333, alpha: 1)) : Color(#colorLiteral(red: 0.1514667571, green: 0.158391118, blue: 0.1616251171, alpha: 1)))
                }
            }.foregroundColor(.black)
            .padding(.horizontal, 60)
            .padding(.bottom, 40)
        }
    }
}
