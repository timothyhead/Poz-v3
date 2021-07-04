//
//  CalendarWriter.swift
//  Poz
//
//  Created by Kish Parikh on 7/3/21.
//

import SwiftUI
import EventKit
import EventKitUI

struct CalendarChooser: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    @Environment(\.presentationMode) var presentationMode
    let eventStore: EKEventStore
//    @Binding var calendars: Set<EKCalendar>? = []

    func makeUIViewController(context: UIViewControllerRepresentableContext<CalendarChooser>) -> UINavigationController {
        let chooser = EKCalendarChooser(selectionStyle: .single, displayStyle: .writableCalendarsOnly, entityType: .event, eventStore: eventStore)
//        chooser.selectedCalendars = calendars ?? []
        chooser.delegate = context.coordinator
        chooser.showsDoneButton = true
        chooser.showsCancelButton = true
        return UINavigationController(rootViewController: chooser)
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<CalendarChooser>) {
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, EKCalendarChooserDelegate {
        let parent: CalendarChooser

        init(_ parent: CalendarChooser) {
            self.parent = parent
        }

        func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
//            parent.calendars = calendarChooser.selectedCalendars
            parent.presentationMode.wrappedValue.dismiss()
        }

        func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    private func saveSelectedCalendars(_ calendars: Set<EKCalendar>?) {
        if let identifiers = calendars?.compactMap({ $0.calendarIdentifier }) {
            UserDefaults.standard.set(identifiers, forKey: "CalendarIdentifiers")
        }
    }

    
    private func loadSelectedCalendars() -> Set<EKCalendar>? {
        if let identifiers = UserDefaults.standard.stringArray(forKey: "CalendarIdentifiers") {
            let calendars = eventStore.calendars(for: .event).filter({ identifiers.contains($0.calendarIdentifier) })
            guard !calendars.isEmpty else { return nil }
            return Set(calendars)
        } else {
            return nil
        }
    }
}

struct CalendarWriter {
    
    // request access to calendar
    func askAddToCal (eventStore: EKEventStore, start: Date, end: Date, id: String, title: String, notes: String) {
        
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
        
        let cal = getCal(store: store)
        
        if (eventAlreadyExists(store: store, id: id, start: start, end: end)) {
            let predicate = store.predicateForEvents(withStart: start, end: end, calendars: [cal])
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
            event.calendar = cal
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
            
//            let nPozCal = noteCal(pozEntryID: id, calEventID: event.eventIdentifier)
//            calMap.add(nPozCal)
        }
    }
    
    func eventAlreadyExists(store: EKEventStore, id: String, start: Date, end: Date) -> Bool {

        var eventAlreadyExists = false;
        
        let cal = getCal(store: store)
        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: [cal])
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
    
    func getCal (store: EKEventStore) -> EKCalendar {
        
        let calendars = store.calendars(for: .event)
        
        var calendarFound = false;
        for calendar in calendars {
            if calendar.title == "Personal" {
                calendarFound = true;
                return calendar
            }
        }
        if (calendarFound == false) {
            return calendars[0]
        }
    }
    
    // calendar chooser
    // from https://nemecek.be/blog/16/how-to-use-ekcalendarchooser-in-swift-to-let-user-select-calendar-in-ios
}
