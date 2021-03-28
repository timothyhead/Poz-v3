import SwiftUI
import Foundation

// code adapted from https://www.youtube.com/watch?v=_1uZ4-5dEUI

class SettingsModel: ObservableObject {
    
    @Published var showSettings = false
    @Published var darkMode = false
    @Published var notifications = true
    
    @Published var journalColorAngle: Double = 90
    @Published var journalName: String = "Your Journal"
    @Published var journalEmoji: String = "🤘🏼"
}
    
