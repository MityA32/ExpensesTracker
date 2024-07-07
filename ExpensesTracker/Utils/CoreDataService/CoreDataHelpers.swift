//
//  CoreDataHelpers.swift
//  ExpensesTracker
//
//  Created by Dmytro Hetman on 06.07.2024.
//

import Foundation
import CoreData

enum TransactionType: String {
    case incoming
    case outgoing
}

enum Category: String {
    case groceries
    case taxi
    case electronics
    case restaurant
    case other
}

final class CoreDataService {
    
    lazy private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExpensesTracker")
        container.loadPersistentStores { _, error in
            //Handle error
        }
        
        return container
    }()
    
    private lazy var backgroundContext = {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    private(set) static var shared: CoreDataService = .init()
    
    @discardableResult
    func create<T: NSManagedObject>(_ type: T.Type, _ handler: ((T) -> Void)?) -> T {
        let newObject = T(context: backgroundContext)
        handler?(newObject)
        return newObject
    }
    
    func performWrite(
        async: Bool = false,
        block: @escaping (NSManagedObjectContext) -> Void
    ) {
        
        let write: () -> Void = { [backgroundContext] in
            block(backgroundContext)
            
            if backgroundContext.hasChanges {
                do {
                    try backgroundContext.save()
                } catch {
                    // error.record()
                    print(error)
                }
            }
        }
        
        if async {
            backgroundContext.perform(write)
        } else {
            backgroundContext.performAndWait(write)
        }
            
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type) -> [T] {
        (try? backgroundContext.fetch(type.fetchRequest()) as? [T]) ?? []
    }
    
    func delete(_ object: NSManagedObject) {
        backgroundContext.delete(object)
    }
}

@propertyWrapper
class Fetch<T: NSManagedObject> {
    
    var wrappedValue: [T] {
        if let filter {
            return CoreDataService.shared.fetch(T.self).filter(filter)
        }
        return CoreDataService.shared.fetch(T.self)
    }
    
    var filter: ((T) -> (Bool))?
    
}
