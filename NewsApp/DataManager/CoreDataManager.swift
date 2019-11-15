//
//  CoreDataHelper.swift
//  NewsApp
//
//  Created by Cosme Fulanito on 13/11/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    private func context() -> NSManagedObjectContext {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let persistentContainer = appDelegate.persistentContainer
            let context = persistentContainer.viewContext
        
            return context
        }
        
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
        let container = NSPersistentContainer(name: "NewsApp", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition(description.type == NSInMemoryStoreType )
                                        
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
    
        return container.viewContext
    }

    func getHistoricalSearches() -> [HistoricalSearch] {
        do {
            let fetchRequests = NSFetchRequest<HistoricalSearch>(entityName: "HistoricalSearch")
            let sort = NSSortDescriptor(key: #keyPath(HistoricalSearch.date), ascending: false)
            fetchRequests.sortDescriptors = [sort]
            let results = try context().fetch(fetchRequests)
            
            return results
        } catch let error {
            debugPrint(error)
            return []
        }
    }
    
    func saveHistoricalSearch(term: String, results: Int) {
        let historicalSearch = NSEntityDescription.insertNewObject(forEntityName: "HistoricalSearch", into: context()) as! HistoricalSearch
    
        historicalSearch.term = term
        historicalSearch.results = Int32(results)
        historicalSearch.date = Date()
        
        saveContext()
    }
    
    func deleteHistoricalSearch(historicalSearch: HistoricalSearch) {
        context().delete(historicalSearch)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context().save()
        } catch let error {
            debugPrint(error)
        }
    }
}
