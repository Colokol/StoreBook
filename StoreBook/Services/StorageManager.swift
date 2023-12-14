//
//  StorageManager.swift
//  StoreBook
//
//  Created by Kirill Taraturin on 13.12.2023.
//

import CoreData

final class StorageManager {
    
    // MARK: - Static Properties
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
    
    // MARK: - Init
    private init() {
        viewContext = persistentContainter.viewContext
    }
    
    // MARK: - CRUD
    func create(_ book: BookModel, completion: ((BookData) -> Void)? = nil) {
        let bookData = BookData(context: viewContext)
        bookData.title = book.title
        bookData.category = book.category
        bookData.imageUrl = book.imageUrl?.absoluteString
        bookData.author = book.author
        bookData.isFavorite = true
        completion?(bookData)
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
    
    // пока оставил так, возможно как-то по-другому можно удалять, не через cвойство модели
    func delete(withImageUrl imageUrl: String) {
        let fetchRequest = BookData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", imageUrl)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let objectToDelete = results.first {
                viewContext.delete(objectToDelete)
                print("\(imageUrl) deleted")
                saveContext()
            }
        } catch let error {
            print("Ошибка при удалении объекта: \(error)")
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                print("Your object was successfully saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}