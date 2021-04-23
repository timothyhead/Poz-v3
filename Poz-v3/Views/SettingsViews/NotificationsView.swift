import SwiftUI

// for setting up daily goal and settings
// https://www.youtube.com/watch?v=t0l0-Kx_4l0

// a single reminder object with index, time, and on switch
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
    
    // pass in settings
    @ObservedObject var settings: SettingsModel
    
    @State var notificationsAreOn = false
    
    var body: some View {
        VStack (alignment: .leading) {
            
//            barGoalView(settings: settings)
//                .padding(.top, 60)
            
            // display goal view up top
            HStack (alignment: .center) {
                Spacer()
                bigGoalView(settings: settings)
                Spacer()
           }
            .padding(.top, 60)
            
            Form {
                
                
            
                // stepper to change daily goal number
                HStack {
    //                smallGoalView(settings: settings)
                    
                    Stepper("Entries per day - \(settings.goalNumber)", onIncrement: {
                        settings.goalNumber += 1
                        UserDefaults.standard.set(settings.goalNumber, forKey: "goalNumber")
                    }, onDecrement: {
                        if ( settings.goalNumber > 1) {
                            settings.goalNumber -= 1
                        }
                        UserDefaults.standard.set(settings.goalNumber, forKey: "goalNumber")
                    })
                }
                
                // turn daily notification on/off
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
                
                // show reminder controls for each reminder
                if (notificationsAreOn == true) {
                    ForEach (settings.reminders.indices) { reminderIndex in
                        ReminderSectionView(settings: settings).environmentObject(settings.reminders[reminderIndex])
                    }
                }
            }
            .navigationTitle("Daily Goal 🎯")
        }
    }
}

// same as above but modified for popup
struct NotificationsViewPopup: View {
    
    @ObservedObject var settings: SettingsModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var notificationsAreOn = false
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading) {
            
//            barGoalView(settings: settings)
//                .padding(.top, 60)
            
                HStack (alignment: .center) {
                    Spacer()
                    bigGoalView(settings: settings)
                    Spacer()
               }
                .padding(.top, 60)
                
                Form {
                    
                    HStack {
        //                smallGoalView(settings: settings)
                        
                        Stepper("Entries per day - \(settings.goalNumber)", onIncrement: {
                            settings.goalNumber += 1
                            UserDefaults.standard.set(settings.goalNumber, forKey: "goalNumber")
                        }, onDecrement: {
                            if ( settings.goalNumber > 0) {
                                settings.goalNumber -= 1
                            }
                            UserDefaults.standard.set(settings.goalNumber, forKey: "goalNumber")
                        })
                    }
                    
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
                            ReminderSectionView(settings: settings).environmentObject(settings.reminders[reminderIndex])
                        }
                    }
                }
                .navigationTitle("Daily Goal 🎯")
                    
                .navigationBarItems(trailing: Button(action: {
    //                self.settings.darkMode = self.darkMode
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                }))
            }
        }
    }
}

// for onboarding, similar to above
struct NotificationsViewOnboard: View {
    
    @ObservedObject var settings: SettingsModel
    
    @State var notificationsAreOn = false
    
    var body: some View {
        VStack (alignment: .center) {
            VStack {
                Text("Be Consistent")
                        .font(Font.custom("Blueberry", size: 28))
                        .foregroundColor(.primary)
                Text("Set a daily goal (2 is fine) and use notifications to support your daily journaling habit")
                        .font(Font.custom("Poppins-Light", size: 18))
                        .foregroundColor(Color(#colorLiteral(red: 0.4156862745, green: 0.4156862745, blue: 0.4156862745, alpha: 1)))
                
            }
            .padding()
            
            HStack (alignment: .center) {
                Spacer()
                bigGoalView(settings: settings)
                    .onAppear() {
                        settings.goalNumber = 2
                        UserDefaults.standard.set(Int(2), forKey: "goalNumber")
                    }
                Spacer()
           }
            
            
            Form {
                
                
            HStack {
//                smallGoalView(settings: settings)
                
                
                Stepper("Entries per day - \(settings.goalNumber)", onIncrement: {
                    settings.goalNumber += 1
                    UserDefaults.standard.set(settings.goalNumber, forKey: "goalNumber")
                }, onDecrement: {
                    if ( settings.goalNumber > 0) {
                        settings.goalNumber -= 1
                    }
                    UserDefaults.standard.set(settings.goalNumber, forKey: "goalNumber")
                })
            }
            
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
                    ReminderSectionView(settings: settings).environmentObject(settings.reminders[reminderIndex])
                }
            }
        }
        }
        .multilineTextAlignment(.center)
        .padding(.top, 60)
        .padding(.bottom, 80)
    }
}

// a single reminder object, with toggle, and time picker
struct ReminderSectionView: View {
    
    @EnvironmentObject var reminder: reminderObject
    @ObservedObject var settings: SettingsModel
    
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.createdAt, ascending: true)]) var notes: FetchedResults<Note>
    
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
                // creates notification as time changes
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
                    content.title = "Hit Poz"
                    content.subtitle = "Complete your daily goal. Take a moment to reflect"
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
    
    // count entries today to output, not in use
    func countEntriesToday () -> Int {
        
        var entriesToday = 0
        for note in notes {
            
            let isToday = Calendar.current.isDateInToday(note.createdAt ?? Date().addingTimeInterval(100000))
            
            if (isToday && note.note != settings.welcomeText && note.note != "") {
                entriesToday += 1
            }
        }
        return entriesToday
    }
}



