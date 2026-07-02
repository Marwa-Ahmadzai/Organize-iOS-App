//
//  SearchView.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI

// MARK: - Search Result Model (MOVED TO TOP)
struct SearchResultItem: Identifiable {
    let id = UUID()
    let title: String
    let category: String // "Event", "Reminder", "Transaction"
    let icon: String
    let destination: Int // Tab index: 0=Calendar, 1=ToDos, 2=Finance
}

struct SearchView: View {
    @State private var searchText = ""
    @EnvironmentObject var tabRouter: TabRouter
    
    // Build search results from real data
    var searchResults: [SearchResultItem] {
        var results: [SearchResultItem] = []
        
        // Add events from Calendar
        for event in tabRouter.allEvents {
            results.append(SearchResultItem(
                title: event.title,
                category: "Event",
                icon: "calendar.circle.fill",
                destination: 0
            ))
        }
        
        // Add reminders from ToDo
        for reminder in tabRouter.allReminders {
            results.append(SearchResultItem(
                title: reminder.title,
                category: "Reminder",
                icon: "checklist",
                destination: 1
            ))
        }
        
        // Add transactions from Finance
        for transaction in tabRouter.allTransactions {
            results.append(SearchResultItem(
                title: transaction.title,
                category: "Transaction",
                icon: "dollarsign.circle.fill",
                destination: 2
            ))
        }
        
        return results
    }
    
    var filteredResults: [SearchResultItem] {
        if searchText.isEmpty {
            return searchResults
        }
        return searchResults.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // Group results by category
    var groupedResults: [String: [SearchResultItem]] {
        Dictionary(grouping: filteredResults) { $0.category }
    }
    
    var sortedCategories: [String] {
        groupedResults.keys.sorted()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(12)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Search Results
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        // Show "Q Pay" header when searching for "pay"
                        if !searchText.isEmpty && searchText.lowercased().contains("pay") {
                            Text("Q Pay")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                        }
                        
                        // Show grouped results
                        if filteredResults.isEmpty && !searchText.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                Text("No results found")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                        } else if searchResults.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "tray")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                Text("No items to search")
                                    .foregroundColor(.secondary)
                                Text("Add events, reminders, or transactions first")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                        } else {
                            ForEach(sortedCategories, id: \.self) { category in
                                // Category Header
                                Text(category)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .padding(.top, 12)
                                    .padding(.bottom, 4)
                                
                                // Results in this category
                                ForEach(groupedResults[category] ?? []) { result in
                                    Button(action: {
                                        tabRouter.selectedTab = result.destination
                                    }) {
                                        HStack {
                                            Image(systemName: result.icon)
                                                .foregroundColor(categoryColor(result.category))
                                                .frame(width: 24)
                                            
                                            Text(result.title)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                        .background(
                                            Color.gray.opacity(0.05)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Divider()
                                        .padding(.leading, 40)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func categoryColor(_ category: String) -> Color {
        switch category {
        case "Event":
            return .blue
        case "Reminder":
            return .orange
        case "Transaction":
            return .green
        default:
            return .secondary
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(TabRouter())
            .preferredColorScheme(.dark)
    }
}
