//
//  ImageDownloadableViewModel.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import UIKit

class ImageDownloadableViewModel {
    var title: String
    var imageUrl: URL
    var image: UIImage?
    
    init(title: String, imageUrl: URL, image: UIImage? = nil) {
        self.title = title
        self.imageUrl = imageUrl
        self.image = image
    }
    
    func loadImage(completion: @escaping (Bool) -> ()) -> URLSessionTask? {
        return MovieImageCachedDownloader.loadImage(from: self.imageUrl) { result in
            switch(result) {
            case .success(let image):
                self.image = image
                completion(true)
            case .failure(let error):
#if DEBUG
                print("Image download error: \(error.localizedDescription)")
#endif
                completion(false)
            }
        }
    }
}
