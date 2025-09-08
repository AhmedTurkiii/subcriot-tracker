//
//  SubscriptionViewModel.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import Foundation
import CoreData
import SwiftUI

class SubscriptionViewModel: ObservableObject {
    @Published var subscriptions: [Subscription] = []
    @Published var totalMonthlyCost: Double = 0.0
    @Published var totalYearlyCost: Double = 0.0
    @Published var upcomingRenewals: [Subscription] = []
    @Published var categories: [String: Double] = [:]
    
    private let persistenceController = PersistenceController.shared
    
    init() {
        loadSubscriptions()
        calculateTotals()
    }
    
    func loadSubscriptions() {
        let request: NSFetchRequest<Subscription> = Subscription.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Subscription.nextBillingDate, ascending: true)]
        
        do {
            subscriptions = try persistenceController.container.viewContext.fetch(request)
            calculateTotals()
            loadUpcomingRenewals()
            calculateCategories()
        } catch {
            print("Error loading subscriptions: \(error)")
        }
    }
    
    func addSubscription(name: String, serviceName: String, category: String, amount: Double, currency: String, billingCycle: String, nextBillingDate: Date, paymentMethod: String, notes: String = "") {
        let context = persistenceController.container.viewContext
        let subscription = Subscription(context: context)
        
        subscription.id = UUID()
        subscription.name = name
        subscription.serviceName = serviceName
        subscription.category = category
        subscription.amount = amount
        subscription.currency = currency
        subscription.billingCycle = billingCycle
        subscription.nextBillingDate = nextBillingDate
        subscription.paymentMethod = paymentMethod
        subscription.notes = notes
        subscription.isActive = true
        subscription.usagePercentage = 0.0
        subscription.isEssential = false
        subscription.createdAt = Date()
        subscription.updatedAt = Date()
        
        saveContext()
        loadSubscriptions()
    }
    
    func updateSubscription(_ subscription: Subscription, name: String, serviceName: String, category: String, amount: Double, currency: String, billingCycle: String, nextBillingDate: Date, paymentMethod: String, notes: String = "") {
        subscription.name = name
        subscription.serviceName = serviceName
        subscription.category = category
        subscription.amount = amount
        subscription.currency = currency
        subscription.billingCycle = billingCycle
        subscription.nextBillingDate = nextBillingDate
        subscription.paymentMethod = paymentMethod
        subscription.notes = notes
        subscription.updatedAt = Date()
        
        saveContext()
        loadSubscriptions()
    }
    
    func deleteSubscription(_ subscription: Subscription) {
        persistenceController.container.viewContext.delete(subscription)
        saveContext()
        loadSubscriptions()
    }
    
    func toggleSubscriptionStatus(_ subscription: Subscription) {
        subscription.isActive.toggle()
        subscription.updatedAt = Date()
        saveContext()
        loadSubscriptions()
    }
    
    private func calculateTotals() {
        totalMonthlyCost = subscriptions.filter { $0.isActive }.reduce(0) { total, subscription in
            let monthlyAmount = subscription.billingCycle == "Yearly" ? subscription.amount / 12 : subscription.amount
            return total + monthlyAmount
        }
        
        totalYearlyCost = subscriptions.filter { $0.isActive }.reduce(0) { total, subscription in
            let yearlyAmount = subscription.billingCycle == "Monthly" ? subscription.amount * 12 : subscription.amount
            return total + yearlyAmount
        }
    }
    
    private func loadUpcomingRenewals() {
        let calendar = Calendar.current
        let thirtyDaysFromNow = calendar.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        
        upcomingRenewals = subscriptions.filter { subscription in
            guard let nextBillingDate = subscription.nextBillingDate else { return false }
            return subscription.isActive && nextBillingDate <= thirtyDaysFromNow
        }
    }
    
    private func calculateCategories() {
        categories = Dictionary(grouping: subscriptions.filter { $0.isActive }, by: { $0.category ?? "Other" })
            .mapValues { subscriptions in
                subscriptions.reduce(0) { total, subscription in
                    let monthlyAmount = subscription.billingCycle == "Yearly" ? subscription.amount / 12 : subscription.amount
                    return total + monthlyAmount
                }
            }
    }
    
    private func saveContext() {
        do {
            try persistenceController.container.viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
