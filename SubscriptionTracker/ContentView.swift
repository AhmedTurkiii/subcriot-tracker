//
//  ContentView.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var subscriptionViewModel = SubscriptionViewModel()
    @StateObject private var financialAdvisorViewModel = FinancialAdvisorViewModel()
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Dashboard")
                }
            
            SubscriptionListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Subscriptions")
                }
            
            FinancialAdvisorView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("Advisor")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .environmentObject(subscriptionViewModel)
        .environmentObject(financialAdvisorViewModel)
    }
}

#Preview {
    ContentView()
}
