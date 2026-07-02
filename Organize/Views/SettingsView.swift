//
//  SettingsView.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled = true
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Label("Account", systemImage: "person.circle")
                    Label("Password", systemImage: "lock")
                    Label("E-Mail", systemImage: "envelope")
                }
                
                Section("General") {
                    Label("Language", systemImage: "globe")
                        .badge("English")
                    Label("Time Zone", systemImage: "clock")
                        .badge("EST")
                    Toggle("Notifications", isOn: $isNotificationsEnabled)
                }
                
                Section("Preferences") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    Label("Colour Style", systemImage: "paintpalette")
                }
                
                Section("About") {
                    Label("Version", systemImage: "info.circle")
                        .badge("1.0.0")
                    Label("Privacy Police", systemImage: "hand.raised")
                    Label("Terms of Use", systemImage: "doc.text")
                    Label("Rate the App", systemImage: "star")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
