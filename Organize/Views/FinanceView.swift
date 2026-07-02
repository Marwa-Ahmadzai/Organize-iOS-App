//
//  FinanceView.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI

struct FinanceView: View {
    @State private var transactions: [Transaction] = [
        Transaction(title: "John Doe - Outgoing payment", amount: 25.00, date: Date(), isOutgoing: true),
        Transaction(title: "Mc Donald's NYC - Outgoing payment", amount: 15.00, date: Date().addingTimeInterval(-86400), isOutgoing: true),
        Transaction(title: "Ikea - Outgoing payment", amount: 150.00, date: Date().addingTimeInterval(-172800), isOutgoing: true),
        Transaction(title: "Incoming payment", amount: 800.00, date: Date().addingTimeInterval(-259200), isOutgoing: false)
    ]
    @State private var showingAddTransaction = false
    @EnvironmentObject var tabRouter: TabRouter  // ← ADD THIS
    
    var totalIncome: Double {
        transactions.filter { !$0.isOutgoing }.reduce(0) { $0 + $1.amount }
    }
    
    var totalOutgoing: Double {
        transactions.filter { $0.isOutgoing }.reduce(0) { $0 + $1.amount }
    }
    
    var remaining: Double {
        totalIncome - totalOutgoing
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Remaining Balance Card
                VStack(spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Remaining for January")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(remaining, specifier: "%.2f")€")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(remaining >= 0 ? .green : .red)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Monthly limit:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("1000,00€")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Statistics Chart
                    HStack(spacing: 30) {
                        VStack {
                            Text("Income")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            let incomePercent = totalIncome > 0 ? (totalIncome / (totalIncome + totalOutgoing) * 100) : 0
                            Text("\(Int(incomePercent))%")
                                .font(.headline)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.green)
                                .frame(width: 40, height: CGFloat(incomePercent / 1.5))
                        }
                        VStack {
                            Text("Outgoings")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            let outgoingPercent = totalOutgoing > 0 ? (totalOutgoing / (totalIncome + totalOutgoing) * 100) : 0
                            Text("\(Int(outgoingPercent))%")
                                .font(.headline)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.red)
                                .frame(width: 40, height: CGFloat(outgoingPercent / 1.5))
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Transactions List
                List {
                    ForEach(transactions) { transaction in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(transaction.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            HStack {
                                Text(transaction.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(transaction.isOutgoing ? "-" : "+")
                                    .foregroundColor(transaction.isOutgoing ? .red : .green)
                                + Text("\(transaction.amount, specifier: "%.2f")€")
                                    .foregroundColor(transaction.isOutgoing ? .red : .green)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        transactions.remove(atOffsets: indexSet)
                        tabRouter.allTransactions = transactions  // ← ADD THIS
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Money Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(transactions: $transactions, isPresented: $showingAddTransaction)
                    .environmentObject(tabRouter)  // ← ADD THIS
            }
            .onChange(of: transactions) { newTransactions in
                tabRouter.allTransactions = newTransactions  // ← ADD THIS
            }
            .onAppear {
                tabRouter.allTransactions = transactions  // ← ADD THIS
            }
        }
    }
}

struct FinanceView_Previews: PreviewProvider {
    static var previews: some View {
        FinanceView()
            .environmentObject(TabRouter())
            .preferredColorScheme(.dark)
    }
}
