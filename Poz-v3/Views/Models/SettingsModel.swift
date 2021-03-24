import SwiftUI
import Foundation

// code adapted from https://www.youtube.com/watch?v=_1uZ4-5dEUI

class SettingsModel: ObservableObject {
    @Published var showSettings = false
    
    @Published var darkMode = false
}
    
