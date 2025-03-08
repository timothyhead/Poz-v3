//  from Filip Němeček https://github.com/nemecek-filip/EKEventKit.Example/blob/master/SwiftUI/EventKit.Example/EventKit.Example/EventsRepository.swift

import SwiftUI
import EventKit
import EventKitUI

struct CalendarController: View {
    enum ActiveSheet {
        case calendarChooser
    }
    
    @State private var showingSheet = false
    @State private var activeSheet: ActiveSheet = .calendarChooser
    
    @ObservedObject var eventsRepository = EventsRepository.shared
    
    @State private var selectedEvent: EKEvent?
    
    var body: some View {
        CalendarChooser(calendars: self.$eventsRepository.selectedCalendars, eventStore: self.eventsRepository.eventStore)
    }
    
    func askToAddToCal (start: Date, end: Date, id: String, title: String, notes: String) {
        CalendarWriter().askAddToCal(eventStore: self.eventsRepository.eventStore, start: start, end: end, id: id, title: title, notes: notes)
    }
}

struct SelectedCalendarsList: View {
    
    @ObservedObject var eventsRepository = EventsRepository.shared
    
    var body: some View {
        
        VStack {
            Text(self.eventsRepository.selectedCalendars?.first!.title ?? "No title")
        }
//        .foregroundColor(Color(eventsRepository.selectedCalendars.first!.cgColor))
        
    }
}

struct CalendarChooser: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var calendars: Set<EKCalendar>?
    
    let eventStore: EKEventStore
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CalendarChooser>) -> UINavigationController {
        let chooser = EKCalendarChooser(selectionStyle: .single, displayStyle: .writableCalendarsOnly, entityType: .event, eventStore: eventStore)
        chooser.selectedCalendars = calendars ?? []
        chooser.delegate = context.coordinator
//        chooser.showsDoneButton = true
//        chooser.showsCancelButton = true
        return UINavigationController(rootViewController: chooser)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<CalendarChooser>) {
        
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, EKCalendarChooserDelegate {
        let parent: CalendarChooser
        
        init(_ parent: CalendarChooser) {
            self.parent = parent
        }
        
        func calendarChooserSelectionDidChange(_ calendarChooser: EKCalendarChooser) {
            parent.calendars = calendarChooser.selectedCalendars
        }
        
        func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
            parent.calendars = calendarChooser.selectedCalendars
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CalendarWriter {
    
    // request access to calendar
    func askAddToCal (eventStore: EKEventStore, start: Date, end: Date, id: String, title: String, notes: String) {
        
        @ObservedObject var eventsRepository = EventsRepository.shared
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            eventStore.requestAccess(to: .event) { (status, error) in
                if status {
                    self.addORUpdateEvent(store: eventStore, id: id, start: start, end: end, title: title, notes: notes)
                } else {
                    print (error?.localizedDescription ?? "Error")
                }
            }
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorized:
            print("Authorized")
            self.addORUpdateEvent(store: eventStore, id: id, start: start, end: end, title: title, notes: notes)
        @unknown default:
            print("Unknown default")
        }
    }
    
    // add event to calendar
    func addORUpdateEvent (store: EKEventStore, id: String, start: Date, end: Date, title: String, notes: String) {
        
        @ObservedObject var eventsRepository = EventsRepository.shared
        
        if (eventAlreadyExists(store: store, id: id, start: start, end: end)) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let startDate = dateFormatter.date(from: "2021-01-01")!
            let endDate = dateFormatter.date(from: "2021-12-31")!
            let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: Array(eventsRepository.selectedCalendars!))
            
            
            let existingEvents = store.events(matching: predicate)
            
            for existingEvent in existingEvents {
                if (checkIDs(ogEvent: existingEvent, id: id)) {
                    print(existingEvent.title ?? "No title");
                    existingEvent.startDate = start
                    existingEvent.title = title
                    existingEvent.endDate = end
                    existingEvent.notes = notes
                    
                    do {
                        try store.save(existingEvent, span: .thisEvent)
                        print ("Event updated in calendar")
                    } catch {
                        print (error.localizedDescription)
                    }
                }
            }
        } else {
            let event = EKEvent(eventStore: store)
            event.calendar = Array(eventsRepository.selectedCalendars!).first
            event.startDate = start
            event.title = title
            event.isAllDay = true;
            event.endDate = end
            event.notes = notes
            
            do {
                try store.save(event, span: .thisEvent)
                print ("Event added to calendar")
            } catch {
                print (error.localizedDescription)
            }
        }
    }
    
    func eventAlreadyExists(store: EKEventStore, id: String, start: Date, end: Date) -> Bool {

        @ObservedObject var eventsRepository = EventsRepository.shared
        
        var eventAlreadyExists = false;
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let startDate = dateFormatter.date(from: "2021-01-01")!
        let endDate = dateFormatter.date(from: "2021-12-31")!
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: Array(eventsRepository.selectedCalendars!))
        
        let existingEvents = store.events(matching: predicate)
        
        eventAlreadyExists = existingEvents.contains { (event) -> Bool in
            
            if (checkIDs(ogEvent: event, id: id))  {
                return true;
            } else {
                return false;
            }
        }
        
        return eventAlreadyExists
    }
    
    func checkIDs (ogEvent: EKEvent, id: String) -> Bool {
        if (ogEvent.notes?.contains(id) == true) {
            return true;
        } else {
            return false
        }
    }
}
