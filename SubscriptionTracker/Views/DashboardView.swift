//
//  DashboardView.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    @EnvironmentObject var financialAdvisorViewModel: FinancialAdvisorViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Financial Health Score Card
                    FinancialHealthCard()
                    
                    // Monthly Spending Overview
                    MonthlySpendingCard()
                    
                    // Upcoming Renewals
                    UpcomingRenewalsCard()
                    
                    // Category Breakdown Chart
                    CategoryBreakdownChart()
                    
                    // Quick Actions
                    QuickActionsCard()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .refreshable {
                subscriptionViewModel.loadSubscriptions()
                financialAdvisorViewModel.analyzeSubscriptions(subscriptionViewModel.subscriptions)
            }
        }
    }
}

struct FinancialHealthCard: View {
    @EnvironmentObject var financialAdvisorViewModel: FinancialAdvisorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Financial Health")
                    .font(.headline)
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(healthColor)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(financialAdvisorViewModel.financialHealthScore)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(healthColor)
                    Text("Health Score")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$\(String(format: "%.0f", financialAdvisorViewModel.monthlySavings))")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    Text("Potential Savings")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var healthColor: Color {
        let score = financialAdvisorViewModel.financialHealthScore
        if score >= 80 { return .green }
        else if score >= 60 { return .orange }
        else { return .red }
    }
}

struct MonthlySpendingCard: View {
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Spending")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("$\(String(format: "%.2f", subscriptionViewModel.totalMonthlyCost))")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    Text("This Month")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$\(String(format: "%.2f", subscriptionViewModel.totalYearlyCost))")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    Text("Yearly Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct UpcomingRenewalsCard: View {
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Renewals")
                .font(.headline)
            
            if subscriptionViewModel.upcomingRenewals.isEmpty {
                Text("No upcoming renewals in the next 30 days")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ForEach(subscriptionViewModel.upcomingRenewals.prefix(3)) { subscription in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(subscription.name ?? "Unknown")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(subscription.serviceName ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("$\(String(format: "%.2f", subscription.amount))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            if let date = subscription.nextBillingDate {
                                Text(date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CategoryBreakdownChart: View {
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spending by Category")
                .font(.headline)
            
            if subscriptionViewModel.categories.isEmpty {
                Text("No subscription data available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                Chart(subscriptionViewModel.categories.sorted(by: { $0.value > $1.value }), id: \.key) { category in
                    BarMark(
                        x: .value("Amount", category.value),
                        y: .value("Category", category.key)
                    )
                    .foregroundStyle(.blue)
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct QuickActionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Add Subscription",
                    icon: "plus.circle.fill",
                    color: .blue
                ) {
                    // Add subscription action
                }
                
                QuickActionButton(
                    title: "View Insights",
                    icon: "brain.head.profile",
                    color: .purple
                ) {
                    // View insights action
                }
                
                QuickActionButton(
                    title: "Export Data",
                    icon: "square.and.arrow.up",
                    color: .green
                ) {
                    // Export data action
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DashboardView()
        .environmentObject(SubscriptionViewModel())
        .environmentObject(FinancialAdvisorViewModel())
}
