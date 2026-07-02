//
//  AddEventView.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//
import SwiftUI

struct AddEventView: View {
    @Binding var events: [Event]
    @Binding var isPresented: Bool
    var preSelectedDate: Date? = nil
    
    @State private var title = ""
    @State private var date: Date
    @State private var time = Date()
    @State private var notes = ""
    @EnvironmentObject var tabRouter: TabRouter
    
    init(events: Binding<[Event]>, isPresented: Binding<Bool>, preSelectedDate: Date? = nil) {
        self._events = events
        self._isPresented = isPresented
        self.preSelectedDate = preSelectedDate
        self._date = State(initialValue: preSelectedDate ?? Date())
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
            }
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create Event") {
                        let newEvent = Event(title: title, date: date, time: time, notes: notes)
                        events.append(newEvent)
                        tabRouter.allEvents = events
                        isPresented = false
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(events: .constant([]), isPresented: .constant(true))
            .environmentObject(TabRouter())
            .preferredColorScheme(.dark)
    }
}
