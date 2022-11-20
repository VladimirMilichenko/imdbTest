//
//  MovieCell.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: IBOutlet
    
    @IBOutlet weak var movieTitleTextView: UITextView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    private var imageRequestTask: URLSessionTask?
    
    //MARK: - Class methods
    
    class var identifier: String { return String(describing: self) }
    
    //MARK: - Internal methods
    
    var cellViewModel: MovieTableViewCellViewModel? {
        didSet {
            if let rank = cellViewModel?.rank, let title = cellViewModel?.title {
                movieTitleTextView.text = rank + ". " + title
            }
            
            if let image = cellViewModel?.image {
                self.movieImageView.image = image
            } else if let cellViewModel = self.cellViewModel {
                activityIndicatorView.startAnimating()
                
                imageRequestTask = cellViewModel.loadImage() { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.movieImageView.image = cellViewModel.image
                            self?.activityIndicatorView.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - UITableViewCell override

    override func prepareForReuse() {
        super.prepareForReuse()

        imageRequestTask?.cancel()
        movieImageView.image = nil
        activityIndicatorView.stopAnimating()
    }
}
