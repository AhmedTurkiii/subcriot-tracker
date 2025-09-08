//
//  PersistenceController.swift
//  SubscriptionTracker
//
//  Created by Ahmed Torki on 2025-01-27.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for previews
        let sampleSubscription = Subscription(context: viewContext)
        sampleSubscription.id = UUID()
        sampleSubscription.name = "Netflix"
        sampleSubscription.serviceName = "Netflix"
        sampleSubscription.category = "Entertainment"
        sampleSubscription.amount = 15.99
        sampleSubscription.currency = "USD"
        sampleSubscription.billingCycle = "Monthly"
        sampleSubscription.nextBillingDate = Calendar.current.date(byAdding: .day, value: 15, to: Date())
        sampleSubscription.paymentMethod = "Credit Card"
        sampleSubscription.isActive = true
        sampleSubscription.usagePercentage = 85.0
        sampleSubscription.isEssential = false
        sampleSubscription.createdAt = Date()
        sampleSubscription.updatedAt = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SubscriptionTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
