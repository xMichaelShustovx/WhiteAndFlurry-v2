//
//  FavouredPhotosViewController.swift
//  WhiteAndFlurryTest
//
//  Created by Michael Shustov on 11.01.2022.
//

import UIKit

class FavouredPhotosViewController: UIViewController {

    // MARK: - Properties and variables

    var starredPhotos = PhotosModel.shared.starredPhotos

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }

    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Table View Delegate Methods

extension FavouredPhotosViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starredPhotos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as! PhotoTableViewCell
        cell.selectionStyle = .none
        cell.setupCell(photo: starredPhotos[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController(photo: starredPhotos[indexPath.row])
        present(detailVC, animated: true, completion: nil)
    }
}

// MARK: - Photos Model Delegate Methods

extension FavouredPhotosViewController: PhotosModelProtocol {
    
    func photosRetrieved() {}
    
    func starredPhotosRetrieved() {
        starredPhotos = PhotosModel.shared.starredPhotos
        tableView.reloadData()
    }
    
    func photoByIdRetrieved() {}
}
