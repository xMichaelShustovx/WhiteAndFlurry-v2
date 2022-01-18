//
//  JSONParseManager.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 14.01.2022.
//

import Foundation

class JSONParseManager {
    
    private init() {}
    
    static func parsePhotos(data: Data) -> [Photo]? {
        
        do {
            let results = try JSONDecoder().decode([Result].self, from: data)
            
            var photoArray = [Photo]()
            
            results.forEach { result in
                
                // TODO: Check if photo is in Core Data already and get it for the new array
                
                let photo = JSONParseManager.parseAsPhoto(result: result)

                photoArray.append(photo)
            }
            
            return photoArray
        }
        catch {
            print("Couldn't parse Photos")
            return nil
        }
    }
    
    static func parseSinglePhoto(data: Data) -> Photo? {
        
        do {
            let result = try JSONDecoder().decode(Result.self, from: data)
            
            let photo = JSONParseManager.parseAsPhoto(result: result)
            
            return photo
        }
        catch {
            print("Couldn't parse Photo")
            return nil
        }
    }
    
    private static func parseAsPhoto(result: Result) -> Photo {
        
        let photo = Photo()
        photo.authorName = result.user.name
        photo.created_at = result.created_at
        photo.downloads = Int64(result.downloads ?? -1)
        photo.id = result.id
        photo.location = result.location?.name
        photo.photoURL = result.urls.small
        photo.isStarred = false
        
        return photo
    }
}
