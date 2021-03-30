import SwiftUI
import Foundation

// code adapted from https://www.youtube.com/watch?v=_1uZ4-5dEUI

class SettingsModel: ObservableObject {
    
    @Published var showSettings = false
    @Published var darkMode = false
    @Published var notifications = true
    
    @Published var goalNumber: Int = 4
    
    @Published var journalColorAngle: Double = UserDefaults.standard.double(forKey: "journalColorAngle") 
    @Published var journalName: String = UserDefaults.standard.string(forKey: "journalName") ?? "Your Journal"
    @Published var journalEmoji: String = UserDefaults.standard.string(forKey: "journalEmoji") ?? "🤘🏼"
    @Published var journalPatternIndex: Int =  UserDefaults.standard.integer(forKey: "journalPatternIndex") 
    
    @Published var username: String = UserDefaults.standard.string(forKey: "Username") ?? "You"
    
    @Published var welcomeText: String = """
                    Welcome to Poz, your personal mindful journal. Swipe right to add a note and get started, or keep reading for furthur instructions. Entries will autosave and automatically be added as pages to left in the journal when you exit the page (turn to a different page or closing the notebook). Pretty simple, older entries to the left, newer entries to the right, and the last page is for adding new entries.

                    Explore the buttons in the bottom left of the add note page to customize each post:

                    🎭 - Tag the post with an emoji
                    🎤 - Use speech to text to type your entry
                    📝 - Prompts or actions for your note

                    More buttons:

                    ✖️ - Go back to home screen
                    🔍 - Search/filter through previous entries in a list (appear when there is >1 note)

                    On the home page, sitting on the bottom left of your journal, there is a little circle with a little number (e.g. 1/2) showing how many notes you've added each day out of your goal. This is to encourage you to journal every day. You can edit this in the settings panel. There are other cool customization options in the settings page so go check those out sometime.

                    That's it! Try the different features and see what works best for you. If you run into issues, try quitting the app and coming back. Share your feedback/issues/questions using the feedback button on the home page. Now, take a moment for yourself and begin your mindful journaling practice with Poz.

                    - Poz team
                    """
}
    
