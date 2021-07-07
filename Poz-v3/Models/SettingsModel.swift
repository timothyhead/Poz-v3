import SwiftUI
import Foundation
import EventKit

// code adapted from https://www.youtube.com/watch?v=_1uZ4-5dEUI

class SettingsModel: ObservableObject {
    
    @Published var showSettings = false
    @Published var darkMode = false
    
    @Published var useAuthentication: Bool = UserDefaults.standard.bool(forKey: "useAuthentication") 
    
    @Published var notifications: Bool = UserDefaults.standard.bool(forKey: "NotificationsOn") 
    @Published var goalNumber: Int = UserDefaults.standard.integer(forKey: "goalNumber")
    
    @Published var allPrompts : [String] = [
        "😌 Write about 3 things you’re grateful for today.",
        "😌 What did you accomplish today?",
        "🤠 Write about a happy memory.",
        "🙏🏽 Write about someplace you’ve been that you’re grateful for.",
        "☺️ What’s something about your body or health that you’re grateful for?",
        "🤠 What’s something that you’re looking forward to?",
        "🙏🏽 Look around the room and write about everything you see that you’re grateful for.",
        "😇 How are you able to help others?",
        "😎 What’s an accomplishment you’re proud of?",
        "🪞 My favorite way to spend the day is...",
        "🪞 If I could talk to my teenage self, the one thing I would say is...",
        "🪞 The two moments I’ll never forget in my life are... (Describe them in great detail, and what makes them so unforgettable.)",
        "🪞 Make a list of 30 things that make you smile.",
        "🧘🏽‍♂️ Write about a moment experienced through your body. Making breakfast, going to a party, having a fight, an experience you’ve had or you imagine for your character. Leave out thought and emotion, and let all information be conveyed through the body and senses.",
        "🌝 The words I’d like to live by are...",
        "🌝 I couldn’t imagine living without..",
        "🧘🏽‍♂️ When I’m in pain—physical or emotional—the kindest thing I can do for myself is...",
        "🌝 Make a list of the people in your life who genuinely support you, and whom you can genuinely trust. Then, make time to hang out with them...",
        "🌝 What does unconditional love look like for you?",
        "🌝 What things would you do if you loved yourself unconditionally? How can you act on these things, even if you’re not yet able to love yourself unconditionally?",
        "🔮 I really wish others knew this about me...",
        "🔮 Name what is enough for you.",
        "🧘🏽‍♂️ If my body could talk, it would say...",
        "🔮 Name a compassionate way you’ve supported a friend recently. Then, write down how you can do the same for yourself.",
        "🔮 What do you love about life?",
        "🔮 What always brings tears to your eyes? (As Paulo Coelho has said, “Tears are words that need to be written.”)",
        "🧘🏽‍♂️ Write about a time when your work felt real, necessary and satisfying to you, whether the work was paid or unpaid, professional or domestic, physical or mental.",
        "🔮 Write about your first love—whether it’s a person, place or thing.",
        "🧘🏽‍♂️ Using 10 words, describe yourself.",
        "✨ What’s surprised you the most about your life or life in general?",
        "✨ What can you learn from your biggest mistakes?",
        "✨ I feel most energized when...",
        "✨ Write a list of questions to which you urgently need answers.",
        "✨ Make a list of everything that inspires you—whether books, websites, quotes, people, paintings, stores, or stars in the sky.",
        "✨ What’s one topic you need to learn more about to help you live a more fulfilling life? (Then, follow through and learn more about that topic.)",
        "🧘🏽‍♂️ I feel happiest in my skin when...",
        "✨ Make a list of everything you’d like to say no to.",
        "✨ Make a list of everything you’d like to say yes to.",
        "✨ Write the words you need to hear."
    ]
    
    @Published var gratitudePrompts : [String] = [
        "😌 Write about 3 things you’re grateful for today.",
        "😌 What did you accomplish today?",
        "🤠 Write about a happy memory.",
        "🙏🏽 Write about someplace you’ve been that you’re grateful for.",
        "☺️ What’s something about your body or health that you’re grateful for?",
        "🤠 What’s something that you’re looking forward to?",
        "🙏🏽 Look around the room and write about everything you see that you’re grateful for.",
        " How are you able to help others?",
        "😎 What’s an accomplishment you’re proud of?"
    ]
    
    @Published var introspectPrompts : [String] = [
        "🔮 My favorite way to spend the day is...",
        "🔮 If I could talk to my teenage self, the one thing I would say is...",
        "🔮 The two moments I’ll never forget in my life are... (Describe them in great detail, and what makes them so unforgettable.)",
        "🔮 Make a list of 30 things that make you smile.",
        "🔮 Write about a moment experienced through your body. Making breakfast, going to a party, having a fight, an experience you’ve had or you imagine for your character. Leave out thought and emotion, and let all information be conveyed through the body and senses.",
        "🔮 The words I’d like to live by are...",
        "🔮 I couldn’t imagine living without..",
        "🔮 When I’m in pain—physical or emotional—the kindest thing I can do for myself is...",
        "🔮 Make a list of the people in your life who genuinely support you, and whom you can genuinely trust. Then, make time to hang out with them...",
        "🔮 What does unconditional love look like for you?",
        "🔮 What things would you do if you loved yourself unconditionally? How can you act on these things, even if you’re not yet able to love yourself unconditionally?",
        "🔮 I really wish others knew this about me...",
        "🔮 Name what is enough for you.",
        "🔮 If my body could talk, it would say...",
        "🔮 Name a compassionate way you’ve supported a friend recently. Then, write down how you can do the same for yourself.",
        "🔮 What do you love about life?",
        "🔮 What always brings tears to your eyes? (As Paulo Coelho has said, “Tears are words that need to be written.”)",
        "🔮 Write about a time when your work felt real, necessary and satisfying to you, whether the work was paid or unpaid, professional or domestic, physical or mental.",
        "🔮 Write about your first love—whether it’s a person, place or thing.",
        "🔮 Using 10 words, describe yourself.",
        "🔮 What’s surprised you the most about your life or life in general?",
        "🔮 What can you learn from your biggest mistakes?",
        "🔮 I feel most energized when...",
        "🔮 Write a list of questions to which you urgently need answers.",
        "🔮 Make a list of everything that inspires you—whether books, websites, quotes, people, paintings, stores, or stars in the sky.",
        "🔮 What’s one topic you need to learn more about to help you live a more fulfilling life? (Then, follow through and learn more about that topic.)",
        "🔮 I feel happiest in my skin when...",
        "🔮 Make a list of everything you’d like to say no to.",
        "🔮 Make a list of everything you’d like to say yes to.",
        "🔮 Write the words you need to hear."
    ]
    

    @Published var journalColorAngle: Double = UserDefaults.standard.double(forKey: "journalColorAngle") 
    @Published var journalName: String = UserDefaults.standard.string(forKey: "journalName") ?? "Poz Journal"
    @Published var journalEmoji: String = UserDefaults.standard.string(forKey: "journalEmoji") ?? "🤘🏼"
    @Published var journalPatternIndex: Int = UserDefaults.standard.integer(forKey: "journalPatternIndex")
    
    @Published var username: String = UserDefaults.standard.string(forKey: "Username") ?? ""
    @Published var reminders = [
        reminderObject(reminderIndex: 1, reminderTime: Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "Reminder 1 Time")), reminderIsOn: UserDefaults.standard.bool(forKey: "Reminder 1 On") ),
        reminderObject(reminderIndex: 2, reminderTime: Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "Reminder 2 Time")), reminderIsOn: UserDefaults.standard.bool(forKey: "Reminder 2 On") ),
        reminderObject(reminderIndex: 3, reminderTime: Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "Reminder 3 Time")), reminderIsOn: UserDefaults.standard.bool(forKey: "Reminder 3 On") ),
        reminderObject(reminderIndex: 4, reminderTime: Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "Reminder 4 Time")), reminderIsOn: UserDefaults.standard.bool(forKey: "Reminder 4 On") )
    ]
    
    @Published var welcomeText: String = """
                    Welcome to Poz, your personal mindful journal. Here's a quick guide:

                    👆🏼 - Swipe right or left to navigate between pages.
                    ⌨️ - Tap and type to add an entry

                    ✖️ - Go back to home screen
                    🔍 - Look through previous entries in a list

                    🎭 - Tag the post with an emoji
                    🎤 - Use speech to text to type your entry
                    ⚡️ - Get a random prompt
                    🗑️ - Clear the note
                    📔 - Quick jump between pages

                    If you run into issues, share your feedback/issues/questions using the feedback button on the home page.
                    """
}
    
