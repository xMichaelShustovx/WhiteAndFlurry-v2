//
//  NetworkManager.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 14.01.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func photosDataRetrieved(data: Data?)
    func singlePhotoDataRetrieved(data: Data?)
}

class NetworkManager {
    
    static var delegate: NetworkManagerProtocol?
    
    private static let key = "md0OYnyRYpRWENPnAu0PiBGwVBUzjGLIx66PrtG1TQ4"
    
    private init() {}
    
    static func getPhotos() {
        
        let url = URL(string: "https://api.unsplash.com/photos/random?count=30")
        
        guard url != nil else { return }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(key)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil && data != nil {
                
                delegate?.photosDataRetrieved(data: data)
            }
            else {
                print("Couldn't resume data task to get photos")
                delegate?.photosDataRetrieved(data: nil)
            }
        }
        
        dataTask.resume()
    }
    
    static func getPhotosBySearch(searchString: String) {
        
        let url = URL(string: "https://api.unsplash.com/search/photos?page=1&query=\(searchString.lowercased())")
        
        guard url != nil else { return }
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(key)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil && data != nil {
                
                delegate?.photosDataRetrieved(data: data)
            }
            else {
                print("Couldn't resume data task to get photos by search")
                delegate?.photosDataRetrieved(data: nil)
            }
        }
        
        dataTask.resume()
    }
    
    static func getSinglePhoto(photoId: String) {
        
        let url = URL(string: "https://api.unsplash.com/photos/\(photoId)")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(self.key)", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error == nil && data != nil {
                
                delegate?.singlePhotoDataRetrieved(data: data)
            }
            else {
                print("Couldn't resume data task to get single photo")
                delegate?.singlePhotoDataRetrieved(data: nil)
            }
        }
        
        dataTask.resume()
    }
}
