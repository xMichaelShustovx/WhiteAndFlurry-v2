//
//  PhotoModel.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import Foundation

protocol PhotosModelProtocol {
    
    func photosRetrieved()
    func starredPhotosRetrieved()
    func photoByIdRetrieved()
}

class PhotosModel {
    
    static let shared = PhotosModel()
    
    var photos: [Photo] {
        didSet {
            delegates.forEach {delegate in
                delegate.photosRetrieved()
            }
        }
    }
    
    var starredPhotos: [Photo] {
        didSet {
            delegates.forEach {delegate in
                delegate.starredPhotosRetrieved()
            }
        }
    }
    
    var singlePhoto: Photo? {
        didSet {
            delegates.forEach { delegate in
                delegate.photoByIdRetrieved()
            }
        }
    }
    
    var delegates = [PhotosModelProtocol]()
    
    private init() {
        photos = [Photo]()
        starredPhotos = CoreDataManager.fetchStarredPhotos()
        NetworkManager.delegate = self
        CoreDataManager.delegate = self
    }
    
}

// MARK: - Network Manager Delegate Methods
extension PhotosModel: NetworkManagerProtocol {
    
    func photosDataRetrieved(data: Data?) {
        if let data = data {
            if let photos = JSONParseManager.parsePhotos(data: data) {
                self.photos = photos
            }
        }
    }
    
    func singlePhotoDataRetrieved(data: Data?) {
        if let data = data {
            if let photo = JSONParseManager.parseSinglePhoto(data: data) {
                self.singlePhoto = photo
            }
        }
    }
}

// MARK: - Core Data Manager Delegate Methods

extension PhotosModel: CoreDataManagerProtocol {
    
    func photosSaved() {
        starredPhotos = CoreDataManager.fetchStarredPhotos()
    }
}
