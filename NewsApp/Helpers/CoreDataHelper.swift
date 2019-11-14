//
//  CoreDataHelper.swift
//  NewsApp
//
//  Created by Cosme Fulanito on 13/11/2019.
//  Copyright © 2019 Cosme Fulanito. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    private init() {}
    
    private let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    func getHistoricalSearches() -> [HistoricalSearch] {
        do {
            let fetchRequests = NSFetchRequest<HistoricalSearch>(entityName: "HistoricalSearch")
            let sort = NSSortDescriptor(key: #keyPath(HistoricalSearch.date), ascending: false)
            fetchRequests.sortDescriptors = [sort]
            let results = try context.fetch(fetchRequests)
            
            return results
        } catch let error {
            debugPrint(error)
            return []
        }
    }
    
    func saveHistoricalSearch(term: String, results: Int) {
        let historicalSearch = NSEntityDescription.insertNewObject(forEntityName: "HistoricalSearch", into: context) as! HistoricalSearch
    
        historicalSearch.term = term
        historicalSearch.results = Int32(results)
        historicalSearch.date = Date()
        
        saveContext()
    }
    
    func deleteHistoricalSearch(historicalSearch: HistoricalSearch) {
        context.delete(historicalSearch)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch let error {
            debugPrint(error)
        }
    }
}
