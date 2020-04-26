//
//  NetworkProfilePictureViewController.swift
//  P2PChat
//
//  Created by Anna Rodionova on 19.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NetworkProfilePictureCell"

class NetworkProfilePictureViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate: NetworkProfilePictureViewControllerDelegate?
    
    private var imageDataList: [ImageDataModel]?
    private var images: [String: UIImage] = [:]
    
    private let loader: NetworkProfilePictureLoader = NetworkProfilePictureLoaderImpl()
    
    // MARK: Init navigation bar
    
    @objc private func closeNetworkLoader() {
        dismiss(animated: true, completion: nil)
    }
    
    private func initNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeNetworkLoader))
    }
    
    // MARK: Load image list
    
    private func loadImageList() {
        activityIndicator.startAnimating()
        loader.loadImageList { [weak self] (list) in
            self?.imageDataList = list.images;
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        collectionView.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        loadImageList()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataList?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? NetworkProfilePictureCell else {
            return UICollectionViewCell()
        }
    
        cell.profilePictureImageView.image = UIImage(named: "PlaceholderUser")
        if let imageUrl = imageDataList?[indexPath.item].largeImageURL {
            if let image = images[imageUrl] {
                cell.profilePictureImageView.image = image
            } else {
                loader.loadImage(with: imageUrl) { [weak self] (image) in
                    self?.images[imageUrl] = image
                    DispatchQueue.main.async {
                        cell.profilePictureImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imageUrl = imageDataList?[indexPath.item].largeImageURL, let image = images[imageUrl] {
            delegate?.pictureDidChoosed(image)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.frame.width
        let cellWidth = (viewWidth - 4 * 4) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
