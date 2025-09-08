//
//  SubscriptionListView.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import SwiftUI

struct SubscriptionListView: View {
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    @State private var showingAddSubscription = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(subscriptionViewModel.subscriptions) { subscription in
                    SubscriptionRowView(subscription: subscription)
                }
                .onDelete(perform: deleteSubscriptions)
            }
            .navigationTitle("Subscriptions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddSubscription = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSubscription) {
                AddSubscriptionView()
            }
        }
    }
    
    private func deleteSubscriptions(offsets: IndexSet) {
        for index in offsets {
            let subscription = subscriptionViewModel.subscriptions[index]
            subscriptionViewModel.deleteSubscription(subscription)
        }
    }
}

struct SubscriptionRowView: View {
    let subscription: Subscription
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    @State private var showingEditSubscription = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(subscription.name ?? "Unknown")
                    .font(.headline)
                
                Text(subscription.serviceName ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(subscription.category ?? "Other")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                    
                    if subscription.isEssential {
                        Text("Essential")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(4)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(String(format: "%.2f", subscription.amount))")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(subscription.billingCycle ?? "Monthly")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let nextBillingDate = subscription.nextBillingDate {
                    Text("Next: \(nextBillingDate, style: .date)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            Button("Delete", role: .destructive) {
                subscriptionViewModel.deleteSubscription(subscription)
            }
            
            Button("Edit") {
                showingEditSubscription = true
            }
            .tint(.blue)
        }
        .sheet(isPresented: $showingEditSubscription) {
            EditSubscriptionView(subscription: subscription)
        }
    }
}

struct AddSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    
    @State private var name = ""
    @State private var serviceName = ""
    @State private var category = "Entertainment"
    @State private var amount = ""
    @State private var currency = "USD"
    @State private var billingCycle = "Monthly"
    @State private var nextBillingDate = Date()
    @State private var paymentMethod = ""
    @State private var notes = ""
    
    let categories = ["Entertainment", "Productivity", "Health", "Education", "News", "Shopping", "Other"]
    let currencies = ["USD", "EUR", "GBP", "CAD", "AUD"]
    let billingCycles = ["Monthly", "Yearly"]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Information") {
                    TextField("Subscription Name", text: $name)
                    TextField("Service Name", text: $serviceName)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                
                Section("Financial Details") {
                    HStack {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        
                        Picker("Currency", selection: $currency) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency).tag(currency)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Picker("Billing Cycle", selection: $billingCycle) {
                        ForEach(billingCycles, id: \.self) { cycle in
                            Text(cycle).tag(cycle)
                        }
                    }
                    
                    DatePicker("Next Billing Date", selection: $nextBillingDate, displayedComponents: .date)
                }
                
                Section("Additional Information") {
                    TextField("Payment Method", text: $paymentMethod)
                    TextField("Notes (Optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSubscription()
                    }
                    .disabled(name.isEmpty || serviceName.isEmpty || amount.isEmpty)
                }
            }
        }
    }
    
    private func saveSubscription() {
        guard let amountValue = Double(amount) else { return }
        
        subscriptionViewModel.addSubscription(
            name: name,
            serviceName: serviceName,
            category: category,
            amount: amountValue,
            currency: currency,
            billingCycle: billingCycle,
            nextBillingDate: nextBillingDate,
            paymentMethod: paymentMethod,
            notes: notes
        )
        
        dismiss()
    }
}

struct EditSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    
    let subscription: Subscription
    
    @State private var name: String
    @State private var serviceName: String
    @State private var category: String
    @State private var amount: String
    @State private var currency: String
    @State private var billingCycle: String
    @State private var nextBillingDate: Date
    @State private var paymentMethod: String
    @State private var notes: String
    
    let categories = ["Entertainment", "Productivity", "Health", "Education", "News", "Shopping", "Other"]
    let currencies = ["USD", "EUR", "GBP", "CAD", "AUD"]
    let billingCycles = ["Monthly", "Yearly"]
    
    init(subscription: Subscription) {
        self.subscription = subscription
        self._name = State(initialValue: subscription.name ?? "")
        self._serviceName = State(initialValue: subscription.serviceName ?? "")
        self._category = State(initialValue: subscription.category ?? "Entertainment")
        self._amount = State(initialValue: String(subscription.amount))
        self._currency = State(initialValue: subscription.currency ?? "USD")
        self._billingCycle = State(initialValue: subscription.billingCycle ?? "Monthly")
        self._nextBillingDate = State(initialValue: subscription.nextBillingDate ?? Date())
        self._paymentMethod = State(initialValue: subscription.paymentMethod ?? "")
        self._notes = State(initialValue: subscription.notes ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Information") {
                    TextField("Subscription Name", text: $name)
                    TextField("Service Name", text: $serviceName)
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                
                Section("Financial Details") {
                    HStack {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        
                        Picker("Currency", selection: $currency) {
                            ForEach(currencies, id: \.self) { currency in
                                Text(currency).tag(currency)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Picker("Billing Cycle", selection: $billingCycle) {
                        ForEach(billingCycles, id: \.self) { cycle in
                            Text(cycle).tag(cycle)
                        }
                    }
                    
                    DatePicker("Next Billing Date", selection: $nextBillingDate, displayedComponents: .date)
                }
                
                Section("Additional Information") {
                    TextField("Payment Method", text: $paymentMethod)
                    TextField("Notes (Optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Edit Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSubscription()
                    }
                    .disabled(name.isEmpty || serviceName.isEmpty || amount.isEmpty)
                }
            }
        }
    }
    
    private func saveSubscription() {
        guard let amountValue = Double(amount) else { return }
        
        subscriptionViewModel.updateSubscription(
            subscription,
            name: name,
            serviceName: serviceName,
            category: category,
            amount: amountValue,
            currency: currency,
            billingCycle: billingCycle,
            nextBillingDate: nextBillingDate,
            paymentMethod: paymentMethod,
            notes: notes
        )
        
        dismiss()
    }
}

#Preview {
    SubscriptionListView()
        .environmentObject(SubscriptionViewModel())
}
