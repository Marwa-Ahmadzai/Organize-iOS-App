//
//  EditEventView.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-25.
//

import SwiftUI

struct EditEventView: View {
    @Binding var events: [Event]
    @Binding var isPresented: Bool
    @State var event: Event
    
    @State private var title: String
    @State private var date: Date
    @State private var time: Date
    @State private var notes: String
    @EnvironmentObject var tabRouter: TabRouter
    
    init(events: Binding<[Event]>, isPresented: Binding<Bool>, event: Event) {
        self._events = events
        self._isPresented = isPresented
        self.event = event
        self._title = State(initialValue: event.title)
        self._date = State(initialValue: event.date)
        self._time = State(initialValue: event.time)
        self._notes = State(initialValue: event.notes)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Event Name", text: $title)
                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                    DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                }
                
                Section {
                    TextField("Put your notes here", text: $notes, axis: .vertical)
                        .frame(height: 80)
                }
                
                Section {
                    Button(action: {
                        // Delete event
                        if let index = events.firstIndex(where: { $0.id == event.id }) {
                            events.remove(at: index)
                            tabRouter.allEvents = events
                            isPresented = false
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Delete Event")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Update event
                        if let index = events.firstIndex(where: { $0.id == event.id }) {
                            events[index].title = title
                            events[index].date = date
                            events[index].time = time
                            events[index].notes = notes
                            tabRouter.allEvents = events
                        }
                        isPresented = false
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct EditEventView_Previews: PreviewProvider {
    static var previews: some View {
        EditEventView(
            events: .constant([]),
            isPresented: .constant(true),
            event: Event(title: "Sample", date: Date())
        )
        .environmentObject(TabRouter())
        .preferredColorScheme(.dark)
    }
}
