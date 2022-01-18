//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Michael Shustov on 16.01.2022.
//
//

import Foundation
import CoreData


extension Photo {

    convenience init() {
        self.init(context: CoreDataManager.context)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var authorName: String?
    @NSManaged public var created_at: String?
    @NSManaged public var downloads: Int64
    @NSManaged public var id: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var isStarred: Bool
    @NSManaged public var location: String?
    @NSManaged public var photoURL: String?

}
