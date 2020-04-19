//
//  NetworkProfilePictureLoaderImpl.swift
//  P2PChat
//
//  Created by Anna Rodionova on 19.04.2020.
//  Copyright © 2020 Veirisa. All rights reserved.
//

import UIKit

class NetworkProfilePictureLoaderImpl: NetworkProfilePictureLoader {

    private let token = "16120560-fd472124ff161a954199e0ad4"
    
    public func loadImageList(callback: @escaping (ImageListModel) -> Void) {
        let session = URLSession.shared
        let imageListUrl = URL(string: "https://pixabay.com/api/?key=\(token)&q=cat&image_type=photo&pretty=true&per_page=100")
        if let imageListUrl = imageListUrl {
            let request = URLRequest(url: imageListUrl)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                } else if let data = data {
                    if let pixabayResponse = try? JSONDecoder().decode(ImageListModel.self, from: data) {
                        callback(pixabayResponse)
                    }
                }
            }
            task.resume()
        }
    }
    
    public func loadImage(with url: String, callback: @escaping (UIImage) -> Void) {
        let session = URLSession.shared
        if let imageUrl = URL(string: url) {
            let request = URLRequest(url: imageUrl)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                } else if let data = data {
                    if let image = UIImage(data: data) {
                        callback(image)
                    }
                }
            }
            task.resume()
        }
    }
}
