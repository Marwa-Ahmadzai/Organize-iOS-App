//
//  ContentView.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tabRouter: TabRouter
    
    var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(0)
            
            TodoListView()
                .tabItem {
                    Label("ToDo List", systemImage: "checklist")
                }
                .tag(1)
            
            FinanceView()
                .tabItem {
                    Label("Finance", systemImage: "dollarsign.circle")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(4)
        }
        .tint(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TabRouter())
            .preferredColorScheme(.dark)
    }
}
