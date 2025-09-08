//
//  SettingsView.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    @State private var notificationsEnabled = true
    @State private var budgetLimit: Double = 100.0
    @State private var currency = "USD"
    @State private var showingExportSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Preferences") {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.blue)
                        Toggle("Notifications", isOn: $notificationsEnabled)
                    }
                    
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text("Monthly Budget Limit")
                            Text("$\(String(format: "%.0f", budgetLimit))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Slider(value: $budgetLimit, in: 0...1000, step: 10)
                            .frame(width: 100)
                    }
                    
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.purple)
                        Text("Currency")
                        Spacer()
                        Picker("Currency", selection: $currency) {
                            Text("USD").tag("USD")
                            Text("EUR").tag("EUR")
                            Text("GBP").tag("GBP")
                            Text("CAD").tag("CAD")
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                
                Section("Data Management") {
                    Button(action: {
                        showingExportSheet = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.blue)
                            Text("Export Data")
                        }
                    }
                    
                    Button(action: {
                        // Import data action
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.green)
                            Text("Import Data")
                        }
                    }
                    
                    Button(action: {
                        // Clear all data action
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            Text("Clear All Data")
                        }
                    }
                }
                
                Section("Financial Services") {
                    Button(action: {
                        // Connect bank account
                    }) {
                        HStack {
                            Image(systemName: "building.2")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Connect Bank Account")
                                Text("Auto-detect subscriptions")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Button(action: {
                        // Connect payment methods
                    }) {
                        HStack {
                            Image(systemName: "creditcard")
                                .foregroundColor(.green)
                            VStack(alignment: .leading) {
                                Text("Payment Methods")
                                Text("Manage cards and accounts")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        // Privacy policy
                    }) {
                        HStack {
                            Image(systemName: "hand.raised")
                                .foregroundColor(.purple)
                            Text("Privacy Policy")
                        }
                    }
                    
                    Button(action: {
                        // Terms of service
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.orange)
                            Text("Terms of Service")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingExportSheet) {
                ExportDataView()
            }
        }
    }
}

struct ExportDataView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Export Your Data")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Export your subscription data to CSV or JSON format for backup or analysis.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ExportButton(
                        title: "Export as CSV",
                        description: "Spreadsheet format",
                        icon: "tablecells",
                        action: {
                            exportAsCSV()
                        }
                    )
                    
                    ExportButton(
                        title: "Export as JSON",
                        description: "Structured data format",
                        icon: "curlybraces",
                        action: {
                            exportAsJSON()
                        }
                    )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func exportAsCSV() {
        // CSV export logic
        print("Exporting as CSV...")
    }
    
    private func exportAsJSON() {
        // JSON export logic
        print("Exporting as JSON...")
    }
}

struct ExportButton: View {
    let title: String
    let description: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
        .environmentObject(SubscriptionViewModel())
}
