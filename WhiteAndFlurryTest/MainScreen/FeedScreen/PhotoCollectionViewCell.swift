//
//  PhotoCollectionViewCell.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 12.01.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties and variables
    
    static let identifier = "PhotoCollectionViewCell"
    
    var photo: Photo?
    
    private var photoImageView: UIImageView = {
        let result = UIImageView()
        result.contentMode = .scaleAspectFill
        result.clipsToBounds = true
        return result
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        photoImageView.frame = self.contentView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.photoImageView.frame = self.contentView.frame
//    }
    
    // MARK: - Public Methods
    
    func displayPhoto(photo: Photo) {
        
        // Set photo property
        self.photo = photo
        
        // Check if the image is in cache
        if let image = ImageCacheService.getImage(url: photo.photoURL) {
            
            // Use cached image
            photoImageView.image = image
            
            // Skip rest of the code
            return
        }
        
        // Download the image
        let url = URL(string: photo.photoURL ?? "")

        guard url != nil else { return }

        let session = URLSession.shared

        let dataTask = session.dataTask(with: url!) { data, _, error in
            if error == nil && data != nil {

                // Check if we downloaded the right image for current cell
                if url!.absoluteString != self.photo?.photoURL {
                    return
                }
                
                self.photo?.imageData = data
                
                // Get the image
                let image = UIImage(data: data!)
                
                // Store the image data in cache
                ImageCacheService.saveImage(url: url!.absoluteString, image: image)

                // Set the image view
                DispatchQueue.main.async {

                    self.photoImageView.image = image
                }
            }
        }

        // Start the data task
        dataTask.resume()
    }
}
