//
//  FinancialAdvisorViewModel.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import Foundation
import SwiftUI

class FinancialAdvisorViewModel: ObservableObject {
    @Published var insights: [FinancialInsight] = []
    @Published var recommendations: [Recommendation] = []
    @Published var financialHealthScore: Int = 0
    @Published var monthlySavings: Double = 0.0
    @Published var isAnalyzing: Bool = false
    
    private let aiService = AIService()
    
    init() {
        generateInsights()
        calculateFinancialHealth()
    }
    
    func analyzeSubscriptions(_ subscriptions: [Subscription]) {
        isAnalyzing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.generateInsights()
            self.generateRecommendations(subscriptions)
            self.calculateFinancialHealth()
            self.isAnalyzing = false
        }
    }
    
    private func generateInsights() {
        insights = [
            FinancialInsight(
                title: "Subscription Overload",
                description: "You have 12 active subscriptions, which is 40% above the average user.",
                type: .warning,
                impact: .high
            ),
            FinancialInsight(
                title: "Unused Services",
                description: "3 subscriptions show less than 20% usage. Consider canceling to save money.",
                type: .suggestion,
                impact: .medium
            ),
            FinancialInsight(
                title: "Payment Optimization",
                description: "Switch 2 subscriptions to annual billing to save $45/year.",
                type: .tip,
                impact: .low
            )
        ]
    }
    
    private func generateRecommendations(_ subscriptions: [Subscription]) {
        recommendations = [
            Recommendation(
                title: "Cancel Unused Subscriptions",
                description: "Cancel Netflix and Spotify - you haven't used them in 3 months.",
                potentialSavings: 29.99,
                difficulty: .easy,
                category: .optimization
            ),
            Recommendation(
                title: "Switch to Annual Billing",
                description: "Switch Adobe Creative Cloud to annual billing to save $120/year.",
                potentialSavings: 120.0,
                difficulty: .medium,
                category: .optimization
            ),
            Recommendation(
                title: "Bundle Services",
                description: "Consider Apple One bundle to save on individual subscriptions.",
                potentialSavings: 15.0,
                difficulty: .hard,
                category: .bundling
            )
        ]
    }
    
    private func calculateFinancialHealth() {
        // Calculate health score based on various factors
        var score = 100
        
        // Deduct points for too many subscriptions
        if insights.contains(where: { $0.title.contains("Overload") }) {
            score -= 20
        }
        
        // Deduct points for unused services
        if insights.contains(where: { $0.title.contains("Unused") }) {
            score -= 15
        }
        
        // Add points for optimization opportunities
        if recommendations.contains(where: { $0.category == .optimization }) {
            score += 10
        }
        
        financialHealthScore = max(0, min(100, score))
        
        // Calculate potential monthly savings
        monthlySavings = recommendations.reduce(0) { total, recommendation in
            return total + (recommendation.potentialSavings / 12)
        }
    }
}

// MARK: - Supporting Models

struct FinancialInsight: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: InsightType
    let impact: ImpactLevel
}

enum InsightType {
    case warning
    case suggestion
    case tip
    case achievement
}

enum ImpactLevel {
    case low
    case medium
    case high
}

struct Recommendation: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let potentialSavings: Double
    let difficulty: DifficultyLevel
    let category: RecommendationCategory
}

enum DifficultyLevel {
    case easy
    case medium
    case hard
}

enum RecommendationCategory {
    case optimization
    case bundling
    case cancellation
    case upgrade
}
