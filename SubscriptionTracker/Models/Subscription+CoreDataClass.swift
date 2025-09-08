//
//  Subscription.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import Foundation
import CoreData

@objc(Subscription)
public class Subscription: NSManagedObject {
    
}

extension Subscription {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subscription> {
        return NSFetchRequest<Subscription>(entityName: "Subscription")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var serviceName: String?
    @NSManaged public var category: String?
    @NSManaged public var amount: Double
    @NSManaged public var currency: String?
    @NSManaged public var billingCycle: String?
    @NSManaged public var nextBillingDate: Date?
    @NSManaged public var isActive: Bool
    @NSManaged public var paymentMethod: String?
    @NSManaged public var notes: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var usagePercentage: Double
    @NSManaged public var isEssential: Bool
}

extension Subscription: Identifiable {
    
}
