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
    
    func loadImage(completion: @escaping () -> ()) -> Cancellable? {
        return MovieImageDownloadService.loadImage(from: self.imageUrl) { image in
            self.image = image
            completion()
        }
    }
}
