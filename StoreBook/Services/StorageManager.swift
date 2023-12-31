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
    private let persistentContainer: NSPersistentContainer = {
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
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func create(_ book: BookModel, imageData: Data?) {
        let bookData = BookData(context: viewContext)
        bookData.title = book.title
        bookData.category = book.category
        bookData.imageUrl = book.imageUrl?.absoluteString
        bookData.author = book.author
        bookData.rating = book.rating ?? 0.0
        bookData.image = imageData
        bookData.isFavorite = true
        NotificationCenter.default.post(name: NSNotification.Name("Saved"), object: nil)
        saveContext()
    }
    func profileData (profile: ProfileView, imageData: Data?) {
        let profileData = ProfileData(context: viewContext)
        profileData.text = profile.textField.text
        profileData.image = imageData
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
    func fetchProfileData(completion: (Result<[ProfileData], Error>) -> Void) {
        let fetchRequest = ProfileData.fetchRequest()
        
        do {
            let profileData = try viewContext.fetch(fetchRequest)
            completion(.success(profileData))
        } catch let error {
            completion(.failure(error))
        }
        
    }
    
    func delete(withImageUrl imageUrl: String) {
        let fetchRequest = BookData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", imageUrl)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let objectToDelete = results.first {
                viewContext.delete(objectToDelete)
                saveContext()
            }
        } catch let error {
            print(error)
        }
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
    
    func deleteAllLikes() {
        let fetchRequest = BookData.fetchRequest()
        
        do {
            let allBooksData = try viewContext.fetch(fetchRequest)
            for bookData in allBooksData {
                viewContext.delete(bookData)
            }
            saveContext()
        } catch let error {
            print("Ошибка при удалении всех данных: \(error)")
        }
    }

}
