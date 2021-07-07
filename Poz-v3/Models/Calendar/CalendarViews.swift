//
//  CalendarViews.swift
//  Poz
//
//  Created by Kish Parikh on 7/7/21.
//

import EventKit
import SwiftUI
import EventKitUI

struct EventEditView: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    let eventStore: EKEventStore
    let event: EKEvent?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<EventEditView>) -> EKEventEditViewController {
        
        let eventEditViewController = EKEventEditViewController()
        eventEditViewController.eventStore = eventStore
        
        if let event = event {
            eventEditViewController.event = event // when set to nil the controller would not display anything
        }
        eventEditViewController.editViewDelegate = context.coordinator
        
        return eventEditViewController
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: UIViewControllerRepresentableContext<EventEditView>) {
        
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        let parent: EventEditView
        
        init(_ parent: EventEditView) {
            self.parent = parent
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
            
            if action != .canceled {
                NotificationCenter.default.post(name: .EKEventStoreChanged, object: nil)
            }
        }
    }
}

struct EventRow: View {
    let event: EKEvent
    
    private static var relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter
    }()
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    private static func formatDate(forNonAllDayEvent event: EKEvent) -> String {
        return "\(EventRow.dateFormatter.string(from: event.startDate)) - \(EventRow.dateFormatter.string(from: event.endDate))"
    }
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10, alignment: .center)
                
            
            VStack(alignment: .leading) {
                Text(EventRow.relativeDateFormatter.localizedString(for: event.startDate, relativeTo: Date()).uppercased())
                    .padding(.bottom, 2)
                Text(event.title)
                    .font(.headline)
            }
            
            Spacer()
            
            VStack {
                Spacer()
                Text(event.isAllDay ? "all day" : EventRow.formatDate(forNonAllDayEvent: event))
            }
        }.padding(.vertical, 5)
    }
}
