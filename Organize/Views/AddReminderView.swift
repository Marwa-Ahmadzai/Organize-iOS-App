//
//  AddReminderView.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI

struct AddReminderView: View {
    @Binding var reminders: [Reminder]
    @Binding var isPresented: Bool
    @State private var title = ""
    @State private var category = "Work"
    @State private var notes = ""
    @EnvironmentObject var tabRouter: TabRouter  // ← ADD THIS
    
    let categories = ["Work", "Family", "Urgent"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Reminder Name", text: $title)
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
                
                Section {
                    TextField("Put your notes here", text: $notes, axis: .vertical)
                        .frame(height: 80)
                }
            }
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create Reminder") {
                        let newReminder = Reminder(title: title, category: category, notes: notes)
                        reminders.append(newReminder)
                        tabRouter.allReminders = reminders  // ← ADD THIS
                        isPresented = false
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct AddReminderView_Previews: PreviewProvider {
    static var previews: some View {
        AddReminderView(reminders: .constant([]), isPresented: .constant(true))
            .environmentObject(TabRouter())
            .preferredColorScheme(.dark)
    }
}
