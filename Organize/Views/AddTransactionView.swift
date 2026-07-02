//
//  AddTransactionView.swift
//  Organize
//
//  Created by Marwa Ahmadzai on 2026-06-24.
//

import SwiftUI

struct AddTransactionView: View {
    @Binding var transactions: [Transaction]
    @Binding var isPresented: Bool
    @State private var title = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var isOutgoing = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount Name", text: $title)
                    TextField("Enter new amount", text: $amount)
                        .keyboardType(.decimalPad)
                    Picker("Type", selection: $isOutgoing) {
                        Text("Outgoing").tag(true)
                        Text("Incoming").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("New Amount")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let amountValue = Double(amount) {
                            let newTransaction = Transaction(
                                title: title,
                                amount: amountValue,
                                date: date,
                                isOutgoing: isOutgoing
                            )
                            transactions.append(newTransaction)
                            isPresented = false
                        }
                    }
                    .disabled(title.isEmpty || amount.isEmpty)
                }
            }
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(transactions: .constant([]), isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
