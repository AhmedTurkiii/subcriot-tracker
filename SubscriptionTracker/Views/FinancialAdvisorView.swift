//
//  FinancialAdvisorView.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import SwiftUI

struct FinancialAdvisorView: View {
    @EnvironmentObject var financialAdvisorViewModel: FinancialAdvisorViewModel
    @EnvironmentObject var subscriptionViewModel: SubscriptionViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // AI Analysis Header
                    AIAnalysisHeader()
                    
                    // Insights Section
                    InsightsSection()
                    
                    // Recommendations Section
                    RecommendationsSection()
                    
                    // Action Items
                    ActionItemsSection()
                }
                .padding()
            }
            .navigationTitle("Financial Advisor")
            .refreshable {
                financialAdvisorViewModel.analyzeSubscriptions(subscriptionViewModel.subscriptions)
            }
        }
    }
}

struct AIAnalysisHeader: View {
    @EnvironmentObject var financialAdvisorViewModel: FinancialAdvisorViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 40))
                    .foregroundColor(.purple)
                
                VStack(alignment: .leading) {
                    Text("AI Financial Advisor")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Powered by advanced analytics")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            if financialAdvisorViewModel.isAnalyzing {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Analyzing your subscriptions...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Analysis complete! Review your insights below.")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct InsightsSection: View {
    @EnvironmentObject var financialAdvisorViewModel: FinancialAdvisorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Key Insights")
                .font(.headline)
            
            ForEach(financialAdvisorViewModel.insights) { insight in
                InsightCard(insight: insight)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct InsightCard: View {
    let insight: FinancialInsight
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(insight.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            ImpactBadge(impact: insight.impact)
        }
        .padding(.vertical, 8)
    }
    
    private var iconName: String {
        switch insight.type {
        case .warning: return "exclamationmark.triangle.fill"
        case .suggestion: return "lightbulb.fill"
        case .tip: return "info.circle.fill"
        case .achievement: return "checkmark.circle.fill"
        }
    }
    
    private var iconColor: Color {
        switch insight.type {
        case .warning: return .orange
        case .suggestion: return .blue
        case .tip: return .green
        case .achievement: return .purple
        }
    }
}

struct ImpactBadge: View {
    let impact: ImpactLevel
    
    var body: some View {
        Text(impactText)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(impactColor.opacity(0.2))
            .foregroundColor(impactColor)
            .cornerRadius(8)
    }
    
    private var impactText: String {
        switch impact {
        case .low: return "Low"
        case .medium: return "Med"
        case .high: return "High"
        }
    }
    
    private var impactColor: Color {
        switch impact {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

struct RecommendationsSection: View {
    @EnvironmentObject var financialAdvisorViewModel: FinancialAdvisorViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Smart Recommendations")
                .font(.headline)
            
            ForEach(financialAdvisorViewModel.recommendations) { recommendation in
                RecommendationCard(recommendation: recommendation)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct RecommendationCard: View {
    let recommendation: Recommendation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recommendation.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(recommendation.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.0f", recommendation.potentialSavings))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("savings/year")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                DifficultyBadge(difficulty: recommendation.difficulty)
                CategoryBadge(category: recommendation.category)
                Spacer()
                
                Button("Apply") {
                    // Apply recommendation action
                }
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct DifficultyBadge: View {
    let difficulty: DifficultyLevel
    
    var body: some View {
        Text(difficultyText)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(difficultyColor.opacity(0.2))
            .foregroundColor(difficultyColor)
            .cornerRadius(4)
    }
    
    private var difficultyText: String {
        switch difficulty {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

struct CategoryBadge: View {
    let category: RecommendationCategory
    
    var body: some View {
        Text(categoryText)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.blue.opacity(0.2))
            .foregroundColor(.blue)
            .cornerRadius(4)
    }
    
    private var categoryText: String {
        switch category {
        case .optimization: return "Optimize"
        case .bundling: return "Bundle"
        case .cancellation: return "Cancel"
        case .upgrade: return "Upgrade"
        }
    }
}

struct ActionItemsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Action Items")
                .font(.headline)
            
            ActionItemRow(
                title: "Review unused subscriptions",
                description: "3 subscriptions show low usage",
                action: "Review"
            )
            
            ActionItemRow(
                title: "Optimize payment methods",
                description: "Switch to annual billing for 2 services",
                action: "Optimize"
            )
            
            ActionItemRow(
                title: "Set spending alerts",
                description: "Configure monthly budget notifications",
                action: "Configure"
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ActionItemRow: View {
    let title: String
    let description: String
    let action: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action) {
                // Action button tapped
            }
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(6)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FinancialAdvisorView()
        .environmentObject(FinancialAdvisorViewModel())
        .environmentObject(SubscriptionViewModel())
}
