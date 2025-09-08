//
//  AIService.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import Foundation
import Combine

class AIService: ObservableObject {
    private let apiKey = "your-openai-api-key" // Replace with actual API key
    private let baseURL = "https://api.openai.com/v1"
    
    func analyzeSubscriptions(_ subscriptions: [Subscription]) -> AnyPublisher<AIAnalysis, Error> {
        // Simulate AI analysis for now
        return Future<AIAnalysis, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let analysis = AIAnalysis(
                    insights: self.generateMockInsights(subscriptions),
                    recommendations: self.generateMockRecommendations(subscriptions),
                    healthScore: self.calculateHealthScore(subscriptions)
                )
                promise(.success(analysis))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func generateMockInsights(_ subscriptions: [Subscription]) -> [String] {
        return [
            "You have \(subscriptions.count) active subscriptions",
            "Total monthly cost: $\(subscriptions.reduce(0) { $0 + $1.amount })",
            "Consider canceling unused services to save money"
        ]
    }
    
    private func generateMockRecommendations(_ subscriptions: [Subscription]) -> [String] {
        return [
            "Switch to annual billing for Netflix to save $20/year",
            "Cancel unused Spotify subscription",
            "Bundle Apple services to reduce costs"
        ]
    }
    
    private func calculateHealthScore(_ subscriptions: [Subscription]) -> Int {
        let totalCost = subscriptions.reduce(0) { $0 + $1.amount }
        let subscriptionCount = subscriptions.count
        
        var score = 100
        
        // Deduct points for high subscription count
        if subscriptionCount > 10 {
            score -= 20
        } else if subscriptionCount > 5 {
            score -= 10
        }
        
        // Deduct points for high monthly cost
        if totalCost > 200 {
            score -= 25
        } else if totalCost > 100 {
            score -= 15
        }
        
        return max(0, score)
    }
}

struct AIAnalysis {
    let insights: [String]
    let recommendations: [String]
    let healthScore: Int
}
