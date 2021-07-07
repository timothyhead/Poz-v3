//  from Filip Němeček https://github.com/nemecek-filip/EKEventKit.Example/blob/master/SwiftUI/EventKit.Example/EventKit.Example/EventsRepository.swift

import Foundation
import EventKit
import SwiftUI
import Combine

typealias Action = () -> ()

class EventsRepository: ObservableObject {
    static let shared = EventsRepository()
    
    let eventStore = EKEventStore()
    
    @Published var selectedCalendars: Set<EKCalendar>?
    
    private init() {
        selectedCalendars = loadSelectedCalendars()
        
        if selectedCalendars == nil {
            if EKEventStore.authorizationStatus(for: .event) == .authorized {
                selectedCalendars = Set([eventStore.defaultCalendarForNewEvents].compactMap({ $0 }))
            }
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
    
    private func saveSelectedCalendars(_ calendars: Set<EKCalendar>?) {
        if let identifiers = calendars?.compactMap({ $0.calendarIdentifier }) {
            UserDefaults.standard.set(identifiers, forKey: "CalendarIdentifiers")
        }
    }
}
