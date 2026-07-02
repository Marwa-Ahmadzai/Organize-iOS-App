//
//  OrganizeApp.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI

@main
struct OrganizeApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @StateObject private var tabRouter = TabRouter()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tabRouter)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
