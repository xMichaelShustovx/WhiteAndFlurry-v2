//
//  CoreDataManager.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 14.01.2022.
//

import Foundation
import UIKit

protocol CoreDataManagerProtocol {
    func photosSaved()
}

class CoreDataManager {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static var delegate: CoreDataManagerProtocol?
    
    private init() {}
    
    static func fetchPhotos() -> [Photo] {
        do {
            let photos = try self.context.fetch(Photo.fetchRequest())
            return photos
        }
        catch {
            print("No photos in Core Data")
            return [Photo]()
        }
    }
    
    static func fetchPhoto(_ photo: Photo) -> Photo? {
        let fetchRequest = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id LIKE %@", photo.id ?? "")
        do {
            let photo = try self.context.fetch(fetchRequest).first
            return photo
        }
        catch {
            print("Error during photo search")
            return nil
        }
    }
    
    static func fetchStarredPhotos() -> [Photo] {
        let fetchRequest = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isStarred == YES")
        do {
            let starredPhotos = try self.context.fetch(fetchRequest)
            return starredPhotos
        }
        catch {
            print("Error during starred photo search")
            return [Photo]()
        }
    }
    
    static func saveContext() {
        
        do {
            try context.save()
        }
        catch {
            print("Couldn't save to CoreData")
            print(error)
        }
    }
    
    static func deletePhoto(_ photo: Photo) {
        context.delete(photo)
    }
}
