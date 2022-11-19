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
    @IBOutlet weak var movieRankLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    private var imageRequest: Cancellable?
    
    //MARK: - Class methods
    
    class var identifier: String { return String(describing: self) }
    
    //MARK: - Internal methods
    
    var cellViewModel: MovieTableViewCellViewModel? {
        didSet {
            activityIndicatorView.startAnimating()
            
            movieTitleTextView.text = cellViewModel?.title
            
            let rankStr = NSLocalizedString("movie_rank_caption", comment: "")
            let undefinedStr = NSLocalizedString("undefined", comment: "")
            
            movieRankLabel.text = rankStr + ": " + (cellViewModel?.rank ?? undefinedStr)
            
            if let imgUrl = cellViewModel?.imageUrl {
                imageRequest = MovieImageDownloadService.loadImage(from: imgUrl) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.movieImageView.image = image
                        self?.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
    
    //MARK: - UITableViewCell override

    override func prepareForReuse() {
        super.prepareForReuse()

        movieImageView.image = nil
        
        imageRequest?.cancel()
    }
}
