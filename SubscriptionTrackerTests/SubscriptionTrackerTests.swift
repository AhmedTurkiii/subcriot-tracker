//
//  SubscriptionTrackerTests.swift
//  SubscriptionTrackerTests
//
//  Created by Ahmed Torki on 2025-01-27.
//

import XCTest
import CoreData
@testable import SubscriptionTracker

final class SubscriptionTrackerTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var subscriptionViewModel: SubscriptionViewModel!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
        subscriptionViewModel = SubscriptionViewModel()
    }
    
    override func tearDownWithError() throws {
        persistenceController = nil
        subscriptionViewModel = nil
    }
    
    func testAddSubscription() throws {
        // Given
        let name = "Netflix"
        let serviceName = "Netflix"
        let category = "Entertainment"
        let amount = 15.99
        let currency = "USD"
        let billingCycle = "Monthly"
        let nextBillingDate = Date()
        let paymentMethod = "Credit Card"
        
        // When
        subscriptionViewModel.addSubscription(
            name: name,
            serviceName: serviceName,
            category: category,
            amount: amount,
            currency: currency,
            billingCycle: billingCycle,
            nextBillingDate: nextBillingDate,
            paymentMethod: paymentMethod
        )
        
        // Then
        XCTAssertEqual(subscriptionViewModel.subscriptions.count, 1)
        XCTAssertEqual(subscriptionViewModel.subscriptions.first?.name, name)
        XCTAssertEqual(subscriptionViewModel.subscriptions.first?.amount, amount)
    }
    
    func testDeleteSubscription() throws {
        // Given
        let subscription = createTestSubscription()
        subscriptionViewModel.addSubscription(
            name: subscription.name!,
            serviceName: subscription.serviceName!,
            category: subscription.category!,
            amount: subscription.amount,
            currency: subscription.currency!,
            billingCycle: subscription.billingCycle!,
            nextBillingDate: subscription.nextBillingDate!,
            paymentMethod: subscription.paymentMethod!
        )
        
        // When
        subscriptionViewModel.deleteSubscription(subscriptionViewModel.subscriptions.first!)
        
        // Then
        XCTAssertEqual(subscriptionViewModel.subscriptions.count, 0)
    }
    
    func testCalculateMonthlyTotal() throws {
        // Given
        let subscription1 = createTestSubscription(amount: 15.99, billingCycle: "Monthly")
        let subscription2 = createTestSubscription(amount: 120.0, billingCycle: "Yearly")
        
        subscriptionViewModel.addSubscription(
            name: subscription1.name!,
            serviceName: subscription1.serviceName!,
            category: subscription1.category!,
            amount: subscription1.amount,
            currency: subscription1.currency!,
            billingCycle: subscription1.billingCycle!,
            nextBillingDate: subscription1.nextBillingDate!,
            paymentMethod: subscription1.paymentMethod!
        )
        
        subscriptionViewModel.addSubscription(
            name: subscription2.name!,
            serviceName: subscription2.serviceName!,
            category: subscription2.category!,
            amount: subscription2.amount,
            currency: subscription2.currency!,
            billingCycle: subscription2.billingCycle!,
            nextBillingDate: subscription2.nextBillingDate!,
            paymentMethod: subscription2.paymentMethod!
        )
        
        // When
        subscriptionViewModel.calculateTotals()
        
        // Then
        let expectedMonthlyTotal = 15.99 + (120.0 / 12) // Monthly + Yearly converted to monthly
        XCTAssertEqual(subscriptionViewModel.totalMonthlyCost, expectedMonthlyTotal, accuracy: 0.01)
    }
    
    func testFinancialHealthScore() throws {
        // Given
        let financialAdvisor = FinancialAdvisorViewModel()
        
        // When
        financialAdvisor.calculateFinancialHealth()
        
        // Then
        XCTAssertGreaterThanOrEqual(financialAdvisor.financialHealthScore, 0)
        XCTAssertLessThanOrEqual(financialAdvisor.financialHealthScore, 100)
    }
    
    private func createTestSubscription(amount: Double = 15.99, billingCycle: String = "Monthly") -> Subscription {
        let context = persistenceController.container.viewContext
        let subscription = Subscription(context: context)
        subscription.id = UUID()
        subscription.name = "Test Subscription"
        subscription.serviceName = "Test Service"
        subscription.category = "Entertainment"
        subscription.amount = amount
        subscription.currency = "USD"
        subscription.billingCycle = billingCycle
        subscription.nextBillingDate = Date()
        subscription.paymentMethod = "Credit Card"
        subscription.isActive = true
        subscription.usagePercentage = 0.0
        subscription.isEssential = false
        subscription.createdAt = Date()
        subscription.updatedAt = Date()
        return subscription
    }
}
