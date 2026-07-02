//
//  ThemeManager.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI
import Combine  // ← IMPORT THIS

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true {
        didSet {
            objectWillChange.send()  // ← Now works with Combine imported
        }
    }
    
    var colorScheme: ColorScheme? {
        isDarkMode ? .dark : .light
    }
}
