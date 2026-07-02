import SwiftUI

struct CalendarView: View {
    @State private var events: [Event] = [
        Event(title: "Meeting", date: createDate(day: 10), time: createTime(hour: 10, minute: 0)),
        Event(title: "Gym", date: createDate(day: 15), time: createTime(hour: 14, minute: 0)),
        Event(title: "Call", date: createDate(day: 20), time: createTime(hour: 9, minute: 0)),
        Event(title: "Daily Meeting with the team", date: Date()),
        Event(title: "Completing the prototype", date: Date().addingTimeInterval(86400)),
        Event(title: "Find people for the user test", date: Date().addingTimeInterval(172800))
    ]
    @State private var showingAddEvent = false
    @State private var showingEditEvent = false
    @State private var selectedEvent: Event?
    @State private var selectedDate: Date?
    @State private var currentDate = Date()
    @State private var eventToEdit: Event?
    @EnvironmentObject var tabRouter: TabRouter
    
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    // Helper to create specific dates
    static func createDate(day: Int) -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 1
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }
    
    static func createTime(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }
    
    // Get current month and year
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
    
    // Get events for a specific day
    private func getEventsForDay(_ day: Int) -> [Event] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        return events.filter { event in
            let eventMonth = calendar.component(.month, from: event.date)
            let eventYear = calendar.component(.year, from: event.date)
            let eventDay = calendar.component(.day, from: event.date)
            return eventDay == day && eventMonth == currentMonth && eventYear == currentYear
        }
    }
    
    // Get days in current month view
    private var calendarDays: [(day: String, isCurrentMonth: Bool)] {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        let firstDay = calendar.date(from: components)!
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        var offset = firstWeekday - 2
        if offset < 0 { offset += 7 }
        
        let range = calendar.range(of: .day, in: .month, for: firstDay)!
        let daysInMonth = range.count
        
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: firstDay)!
        let previousMonthDays = calendar.range(of: .day, in: .month, for: previousMonth)!.count
        
        var days: [(String, Bool)] = []
        
        // Add previous month days
        for i in 0..<offset {
            let day = previousMonthDays - offset + i + 1
            days.append(("\(day)", false))
        }
        
        // Add current month days
        for day in 1...daysInMonth {
            days.append(("\(day)", true))
        }
        
        // Add next month days to complete grid
        let totalDaysNeeded = 35
        let remainingDays = totalDaysNeeded - days.count
        for day in 1...remainingDays {
            days.append(("\(day)", false))
        }
        
        return days
    }
    
    // Check if a day is today
    private func isToday(_ day: String) -> Bool {
        let calendar = Calendar.current
        let currentDay = calendar.component(.day, from: Date())
        let currentMonth = calendar.component(.month, from: Date())
        let currentYear = calendar.component(.year, from: Date())
        
        let calendarMonth = calendar.component(.month, from: currentDate)
        let calendarYear = calendar.component(.year, from: currentDate)
        
        guard let dayInt = Int(day) else { return false }
        return dayInt == currentDay && currentMonth == calendarMonth && currentYear == calendarYear
    }
    
    // Get date from day number
    private func getDateFromDay(_ day: String) -> Date? {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        guard let dayInt = Int(day) else { return nil }
        
        var components = DateComponents()
        components.year = currentYear
        components.month = currentMonth
        components.day = dayInt
        return calendar.date(from: components)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Month Header with Add Event Button (Plus only)
                    HStack {
                        Text(monthYearString)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        HStack(spacing: 12) {
                            // Month Navigation Arrows
                            Button(action: {
                                currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                            }) {
                                Image(systemName: "chevron.left")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(8)
                            }
                            Button(action: {
                                currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                            }) {
                                Image(systemName: "chevron.right")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.15))
                                    .cornerRadius(8)
                            }
                            
                            // Plus Button - Add Event
                            Button(action: {
                                selectedDate = nil
                                showingAddEvent = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.15))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Calendar Grid with clickable dates
                    VStack(spacing: 0) {
                        HStack {
                            ForEach(daysOfWeek, id: \.self) { day in
                                Text(day)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        VStack(spacing: 0) {
                            ForEach(0..<5, id: \.self) { row in
                                HStack(alignment: .top, spacing: 0) {
                                    ForEach(0..<7, id: \.self) { col in
                                        let index = row * 7 + col
                                        if index < calendarDays.count {
                                            let day = calendarDays[index]
                                            let dayNumber = day.day
                                            let isCurrentMonth = day.isCurrentMonth
                                            let isTodayDay = isToday(dayNumber)
                                            let dayInt = Int(dayNumber) ?? 0
                                            let dayEvents = getEventsForDay(dayInt)
                                            
                                            Button(action: {
                                                // When date is clicked, open Add Event with pre-selected date
                                                if let date = getDateFromDay(dayNumber) {
                                                    selectedDate = date
                                                    showingAddEvent = true
                                                }
                                            }) {
                                                VStack(spacing: 2) {
                                                    // Day number
                                                    Text(dayNumber)
                                                        .font(.subheadline)
                                                        .frame(width: 32, height: 32)
                                                        .background(
                                                            isTodayDay ?
                                                                Circle().fill(Color.blue) :
                                                                nil
                                                        )
                                                        .foregroundColor(
                                                            isTodayDay ? .white :
                                                            isCurrentMonth ? .primary : .secondary.opacity(0.5)
                                                        )
                                                    
                                                    // Event indicators
                                                    if !dayEvents.isEmpty && isCurrentMonth {
                                                        VStack(spacing: 1) {
                                                            ForEach(dayEvents.prefix(2), id: \.id) { event in
                                                                Text(event.title)
                                                                    .font(.system(size: 7))
                                                                    .lineLimit(1)
                                                                    .padding(.horizontal, 2)
                                                                    .frame(maxWidth: .infinity)
                                                                    .background(
                                                                        eventColor(event.title)
                                                                            .opacity(0.3)
                                                                    )
                                                                    .cornerRadius(2)
                                                            }
                                                            if dayEvents.count > 2 {
                                                                Text("+\(dayEvents.count - 2)")
                                                                    .font(.system(size: 6))
                                                                    .foregroundColor(.secondary)
                                                            }
                                                        }
                                                        .frame(height: 18)
                                                    } else {
                                                        Spacer()
                                                            .frame(height: 18)
                                                    }
                                                }
                                                .frame(maxWidth: .infinity, minHeight: 55)
                                                .padding(.vertical, 2)
                                                .background(
                                                    selectedDate != nil && isSameDay(date1: selectedDate!, date2: getDateFromDay(dayNumber)!) ?
                                                        Color.blue.opacity(0.2) :
                                                        Color.clear
                                                )
                                                .cornerRadius(8)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Schedule section with clickable events
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Schedule")
                            .font(.headline)
                            .padding(.leading)
                        
                        if events.isEmpty {
                            Text("No events scheduled")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        } else {
                            ForEach(events) { event in
                                Button(action: {
                                    // Click event to edit
                                    eventToEdit = event
                                    showingEditEvent = true
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(event.title)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            Text(event.date, style: .date)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        HStack(spacing: 8) {
                                            Text("10:00 - 11:00")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            // Delete button
                                            Button(action: {
                                                if let index = events.firstIndex(where: { $0.id == event.id }) {
                                                    events.remove(at: index)
                                                    tabRouter.allEvents = events
                                                }
                                            }) {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(
                    events: $events,
                    isPresented: $showingAddEvent,
                    preSelectedDate: selectedDate
                )
                .environmentObject(tabRouter)
            }
            .sheet(isPresented: $showingEditEvent) {
                if let event = eventToEdit {
                    EditEventView(
                        events: $events,
                        isPresented: $showingEditEvent,
                        event: event
                    )
                    .environmentObject(tabRouter)
                }
            }
            .onChange(of: events) { newEvents in
                tabRouter.allEvents = newEvents
            }
            .onAppear {
                tabRouter.allEvents = events
            }
        }
    }
    
    // Helper to check if two dates are the same day
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // Color for event labels
    func eventColor(_ title: String) -> Color {
        switch title.lowercased() {
        case _ where title.contains("Meeting"):
            return .blue
        case _ where title.contains("Gym"):
            return .green
        case _ where title.contains("Call"):
            return .orange
        case _ where title.contains("Daily"):
            return .purple
        default:
            return .blue
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(TabRouter())
            .preferredColorScheme(.dark)
    }
}
