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

struct NotificationsView: View {
    
    @ObservedObject var settings: SettingsModel
    
    @State var notificationsAreOn = false
    
    var body: some View {
        
        Form {
            
            Stepper("Entries per day - \(settings.goalNumber)", onIncrement: {
                settings.goalNumber += 1
                UserDefaults.standard.set(settings.goalNumber, forKey: "goalNumber")
            }, onDecrement: {
                if ( settings.goalNumber > 0) {
                    settings.goalNumber -= 1
                }
                UserDefaults.standard.set(settings.goalNumber, forKey: "goalNumber")
            })
        
            Toggle("Daily Notifications", isOn: $notificationsAreOn)
                .onChange(of: notificationsAreOn) { value in
                    settings.notifications = notificationsAreOn
                    UserDefaults.standard.set(settings.notifications, forKey: "NotificationsOn")
                    
                    if !(settings.notifications) {
                       UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }
                }
                .onAppear() {
                    notificationsAreOn = settings.notifications
                }
            
            if (notificationsAreOn == true) {
                ForEach (settings.reminders.indices) { reminderIndex in
                    ReminderSectionView().environmentObject(settings.reminders[reminderIndex])
                }
            }
        }.navigationTitle("Daily Goal")
    }
}

struct ReminderSectionView: View {
    
    @EnvironmentObject var reminder: reminderObject
    
    var body: some View {
        Section(header: Text("Reminder #\(reminder.reminderIndex)")) {
            
            Button (action: {
                reminder.reminderIsOn.toggle()
                
                UserDefaults.standard.set(reminder.reminderIsOn, forKey: "Reminder \(reminder.reminderIndex) On")
                
                
                if !(reminder.reminderIsOn) {
                   UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                }
            }) {
                Text(reminder.reminderIsOn ? "Remove Reminder" : "Add Reminder")
            }
            
            
            if (reminder.reminderIsOn) {
                DatePicker(
                    "Notification Time",
                    selection: $reminder.reminderTime,
                    displayedComponents: [.hourAndMinute]
                )
                .onChange (of: reminder.reminderTime) {value in
                    
                    UserDefaults.standard.set(reminder.reminderTime.timeIntervalSince1970, forKey: "Reminder \(reminder.reminderIndex) Time")
                    print ("Reminder \(reminder.reminderIndex) Time")
                    
                    UNUserNotificationCenter.current()
                        .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    
                    
//                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
                    print("Done")
                }
            } 
        }
    }
}



