//
//  TodoListView.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI

struct TodoListView: View {
    @State private var reminders: [Reminder] = [
        Reminder(title: "Daily meeting with the team", category: "Work"),
        Reminder(title: "Completing the prototype", category: "Work"),
        Reminder(title: "Find people for the user test", category: "Work"),
        Reminder(title: "Buy cookies for the kids", category: "Family"),
        Reminder(title: "Pay electricity bill", category: "Urgent")
    ]
    @State private var selectedCategory = "All"
    @State private var showingAddReminder = false
    @EnvironmentObject var tabRouter: TabRouter  // ← ADD THIS
    
    let categories = ["All", "Work", "Family", "Urgent"]
    
    var filteredReminders: [Reminder] {
        if selectedCategory == "All" {
            return reminders
        }
        return reminders.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Category Filter Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(category) {
                                selectedCategory = category
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // ToDo List
                List {
                    ForEach(filteredReminders) { reminder in
                        HStack {
                            Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(reminder.isCompleted ? .blue : .secondary)
                                .onTapGesture {
                                    if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                                        reminders[index].isCompleted.toggle()
                                        tabRouter.allReminders = reminders  // ← ADD THIS
                                    }
                                }
                            
                            VStack(alignment: .leading) {
                                Text(reminder.title)
                                    .strikethrough(reminder.isCompleted)
                                    .foregroundColor(reminder.isCompleted ? .secondary : .primary)
                                Text(reminder.category)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        reminders.remove(atOffsets: indexSet)
                        tabRouter.allReminders = reminders  // ← ADD THIS
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("ToDos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    showingAddReminder = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                AddReminderView(reminders: $reminders, isPresented: $showingAddReminder)
                    .environmentObject(tabRouter)  // ← ADD THIS
            }
            .onChange(of: reminders) { newReminders in
                tabRouter.allReminders = newReminders  // ← ADD THIS
            }
            .onAppear {
                tabRouter.allReminders = reminders  // ← ADD THIS
            }
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
            .environmentObject(TabRouter())
            .preferredColorScheme(.dark)
    }
}
