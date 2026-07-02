//
//  DataModels.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import Foundation

// MARK: - Data Models

// Make Event Equatable
struct Event: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var date: Date
    var time: Date = Date()
    var notes: String = ""
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}

// Make Reminder Equatable
struct Reminder: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var category: String // Work, Family, Urgent
    var isCompleted: Bool = false
    var notes: String = ""
    
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.id == rhs.id
    }
}

// Make Transaction Equatable
struct Transaction: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var amount: Double
    var date: Date
    var isOutgoing: Bool = true
    var category: String = ""
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.id == rhs.id
    }
}
