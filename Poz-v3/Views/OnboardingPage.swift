import SwiftUI
import UIKit

struct PageView: View {
    var title: String
    var imageName: String
    var header: String
    var content: String
    var textColor: Color

    let imageWidth: CGFloat = 150
    let textWidth: CGFloat = 350
    
    @ObservedObject var settings: SettingsModel
    
    @State var text = ""

    var body: some View {

        return
            VStack(alignment: .center, spacing: 50) {
                Text(title)
                    .font(Font.custom("Blueberry", size: 44))
                    .foregroundColor(textColor)
                    
//
                Image(imageName)
                    .resizable()
                    .frame(width: imageWidth, height: imageWidth)
                    .cornerRadius(40)
                    .clipped()
                
                VStack(alignment: .center, spacing: 5) {
                    
                    Text(header)
                        .font(Font.custom("Poppins-Bold", size: 26))
                        .foregroundColor(textColor)
                        
                    Text(content)
                        .font(Font.custom("Poppins-Light", size: 16))
                        .foregroundColor(textColor)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
    }
}

struct MockData {
    static let title = "Welcome to Poz"
    static let headers = [
        "Journal",
        "Customize",
        "Track"
    ]
    static let contentStrings = [
        "Document your thoughts, reflect on your day, or respond to prompts.",
        "Change the name, color, emoji and look of your notebook.",
        "Use a daily goal to make sure you check in with yourself regularly."
    ]
    static let imageNames = [
        "screen 1",
        "screen 2",
        "screen 3"
    ]

    static let colors = [
        "F38181",
        "FCE38A",
        "95E1D3"
        ].map{ Color(hex: $0) }

    static let textColors = [
        "FFFFFF",
        "4A4A4A",
        "4A4A4A"
        ].map{ Color(hex: $0) }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff


        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
