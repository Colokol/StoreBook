//
//  StorageManager.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 13.12.2023.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainter: NSPersistentContainer = {
        let contrainter = NSPersistentContainer(name: "BookData")
        contrainter.loadPersistentStores { _,  error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return contrainter
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainter.viewContext
    }
    
    // MARK: - CRUD
    func create(_ book: BookModel, completion: (BookData) -> Void) {
        let bookData = BookData(context: viewContext)
        bookData.title = book.title
        bookData.category = book.category
        bookData.imageUrl = book.imageUrl?.absoluteString
        bookData.author = book.author
        completion(bookData)
        saveContext()
    }
    
    func fetchData(completion: (Result<[BookData], Error>) -> Void) {
        let fetchRequest = BookData.fetchRequest()
        
        do {
            let booksData = try viewContext.fetch(fetchRequest)
            completion(.success(booksData))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func delete(object: NSManagedObject) {
        viewContext.delete(object)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
