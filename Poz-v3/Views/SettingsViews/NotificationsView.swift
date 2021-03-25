import SwiftUI

// https://www.youtube.com/watch?v=t0l0-Kx_4l0

class reminderObject : Identifiable, ObservableObject {

    var reminderIndex: Int
    @Published var reminderTime: Date = Date()
    @Published var reminderIsOn: Bool = false


    init(reminderIndex: Int, reminderTime: Date, reminderIsOn: Bool) {
        self.reminderIndex = reminderIndex
        self.reminderTime = reminderTime
        self.reminderIsOn = reminderIsOn
    }
}

class Reminders :  ObservableObject {
    @Published var reminders = [
        reminderObject(reminderIndex: 1, reminderTime: Date(), reminderIsOn: true),
        reminderObject(reminderIndex: 2, reminderTime: Date(), reminderIsOn: true)
    ]
}


struct NotificationsView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @State var notificationsAreOn = true
    
    @State private var aDate = Date()
    @State private var aBool = false
    
    @EnvironmentObject var reminders: Reminders
    
    
    var body: some View {
        
        Form {
        
            Toggle("Daily Notifications", isOn: $notificationsAreOn)
                .onAppear() {
                    settings.notifications = notificationsAreOn
                }
            if (notificationsAreOn == true) {
                ForEach (reminders.reminders.indices) { reminderIndex in
                    ReminderSectionView().environmentObject(self.reminders.reminders[reminderIndex])
                }
            }
        }
    }
}

struct ReminderSectionView: View {
    
    @EnvironmentObject var reminder: reminderObject
    @State var isOn = true;
    var body: some View {
        Section(header: Text("Reminder #\(reminder.reminderIndex)")) {
            Button (action: {
                reminder.reminderIsOn.toggle()
                isOn = reminder.reminderIsOn
            }) {
                Text(isOn ? "Remove Reminder" : "Add Reminder")
            }
            .onAppear() {
                isOn = reminder.reminderIsOn
            }
            
            if (isOn) {
                DatePicker(
                    "Notification Time",
                    selection: $reminder.reminderTime,
                    displayedComponents: [.hourAndMinute]
                )
                
                Button("Update Time") {
                    
                    UNUserNotificationCenter.current()
                        .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    
                    
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    let content = UNMutableNotificationContent()
                    content.title = "Feed cat"
                    content.subtitle = "its time"
                    content.sound = UNNotificationSound.default
                    
                    let date = reminder.reminderTime
                    let calendar = Calendar.current
                    
                    var dateComponents = DateComponents()
                    
                    dateComponents.hour = calendar.component(.hour, from: date)
                    dateComponents.minute = calendar.component(.minute, from: date)
                    
                    // one time notification
                    // let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  5, repeats: false)
                    
                    //daily notification
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    let request = UNNotificationRequest(identifier: String(reminder.reminderIndex), content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                }
            }
        }
    }
}



