//
//  TabRouter.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI
import Combine

class TabRouter: ObservableObject {
    @Published var selectedTab = 0
    
    // Shared data for search
    @Published var allEvents: [Event] = []
    @Published var allReminders: [Reminder] = []
    @Published var allTransactions: [Transaction] = []
}
