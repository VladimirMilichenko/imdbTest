//
//  BaseViewModel.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import UIKit

class ViewModel {
    var title: String
    var imageUrl: URL
    var image: UIImage?
    
    init(title: String, imageUrl: URL, image: UIImage? = nil) {
        self.title = title
        self.imageUrl = imageUrl
        self.image = image
    }
    
    func loadImage(completion: @escaping (Bool) -> ()) -> URLSessionTask? {
        return MovieImageDownloadService.loadImage(from: self.imageUrl) { image in
            if let img = image {
                self.image = img
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
