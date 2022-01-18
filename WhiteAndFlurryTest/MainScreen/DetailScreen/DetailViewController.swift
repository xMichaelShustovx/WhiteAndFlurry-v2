//
//  DetailViewController.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 12.01.2022.
//

import UIKit
import CoreData
import Brightroom


class DetailViewController: UIViewController {

    // MARK: - Properties and variables
    
    var photo: Photo
    
    var detailView = DetailView()
    
    lazy var isStarred = photo.isStarred {
        didSet {
            let systemImage = isStarred ? "star.fill" : "star"
            detailView.starButton.setImage(UIImage(systemName: systemImage), for: .normal)
        }
    }
    
    // MARK: - Initialization
    
    init(photo: Photo) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = detailView
        PhotosModel.shared.delegates.append(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .pageSheet
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        // Check if image is in CoreData or in cache and set it
        if let imageData = photo.imageData {
            detailView.photoImage.image = UIImage(data: imageData)
        }
        else {
            detailView.photoImage.image = ImageCacheService.getImage(url: photo.photoURL)
        }
        self.detailView.nameLabel.text = "Author: \(photo.authorName ?? "")"
        
        // Set labels of detailed view
        let dateString = self.photo.created_at ?? ""
        let formattedDate = dateString[..<dateString.firstIndex(of: "T")!].replacingOccurrences(of: "-", with: "/")
        detailView.dateLabel.text = "Date: \(formattedDate)"

        detailView.locationLabel.text = "Location: \(photo.location ?? "Unknown")"
        self.detailView.downloadsLabel.text = "Downloads: \(String(photo.downloads))"
        
        // Check if there is location and downloads and ask model to get data if not
        if photo.location == nil || self.photo.downloads == -1 {
            
            NetworkManager.getSinglePhoto(photoId: photo.id ?? "")
        }
        else {
            detailView.starButton.isUserInteractionEnabled = true
        }
        
        // Set action for star button
        self.detailView.starButton.addAction(UIAction(handler: { _ in
            self.starredHandle()
        }), for: .touchUpInside)
        detailView.starButton.addTarget(self, action: #selector(starredHandle), for: .touchUpInside)
        
        // Set action for crop button
        self.detailView.cropButton.addTarget(self, action: #selector(press), for: .touchUpInside)
    }
    
    @objc
    private func starredHandle() {
        
        if isStarred {
            
            photo.isStarred = false
            
            self.isStarred.toggle()
        }
        else {
            
            photo.isStarred = true
            
            CoreDataManager.saveContext()
            
            self.isStarred.toggle()
        }
    }
    
    // MARK: - Brightroom Methods
    @objc
    private func press() {
        
        let image = self.detailView.photoImage.image
        let imageProvider = ImageProvider(image: image ?? UIImage())
        let controller = PhotosCropViewController(imageProvider: imageProvider)
        controller.handlers.didCancel = { controller in
            controller.dismiss(animated: true, completion: nil)
        }
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - Photo Model Delegate Methods

extension DetailViewController: PhotosModelProtocol {
    
    func photosRetrieved() {}
    
    func starredPhotosRetrieved() {}
    
    func photoByIdRetrieved() {
        
        if let photo = PhotosModel.shared.singlePhoto {
            
            if let location = photo.location {
                DispatchQueue.main.async {
                    self.detailView.locationLabel.text = "Location: \(location)"
                }
            }
            
            if photo.downloads != -1 {
                DispatchQueue.main.async {
                    self.detailView.downloadsLabel.text = "Downloads: \(String(photo.downloads))"
                }
            }
        }
        
        // Check if current photo is in CoreData
        
        DispatchQueue.main.async {
            self.detailView.starButton.isUserInteractionEnabled = true
        }
    }
}
