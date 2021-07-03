//
//  CalendarWriter.swift
//  Poz
//
//  Created by Kish Parikh on 7/3/21.
//

import SwiftUI
import EventKit

struct CalendarWriter {
    
    // request access to calendar
    func askAddToCal (start: Date, end: Date, id: String, title: String, notes: String) {
        let eventStore = EKEventStore()
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
            print("b");
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
        }
    }
    
    func eventAlreadyExists(store: EKEventStore, id: String, start: Date, end: Date) -> Bool {

        var eventAlreadyExists = false;
        
        let cal = getCal(store: store)
        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: [cal])
        let existingEvents = store.events(matching: predicate)

        eventAlreadyExists = existingEvents.contains { (event) -> Bool in
            
            if (checkIDs(ogEvent: event, id: id)) {
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
            if calendar.title == "Calendar" {
                calendarFound = true;
                return calendar
            }
        }
        if (calendarFound == false) {
            return calendars[0]
        }
    }
}
