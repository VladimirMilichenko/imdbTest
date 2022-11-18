//
//  UIImageView+CachedImage.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/18/22.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        let request = URLRequest(url: url)
        
        if let data = URLCache.shared.cachedResponse(for: request)?.data,
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.image = image
            }
        } else {
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode,
                      let image = UIImage(data: data) else {
                    return
                }
                
                let cachedData = CachedURLResponse(response: httpResponse, data: data)
                URLCache.shared.storeCachedResponse(cachedData, for: request)
                
                DispatchQueue.main.async {
                    self?.image = image
                }
            }.resume()
        }
    }
}
