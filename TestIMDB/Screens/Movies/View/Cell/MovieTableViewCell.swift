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
    
    //MARK: - Class methods
    
    class var identifier: String { return String(describing: self) }
    
    //MARK: - Internal methods
    
    var cellViewModel: MovieTableViewCellViewModel? {
        didSet {
            movieTitleTextView.text = cellViewModel?.title
            
            let rankStr = NSLocalizedString("movie_rank_caption", comment: "")
            let undefinedStr = NSLocalizedString("undefined", comment: "")
            
            movieRankLabel.text = rankStr + ": " + (cellViewModel?.rank ?? undefinedStr)
            
            if let imgUrl = cellViewModel?.imageUrl {
                movieImageView?.loadImage(from: imgUrl)
            }
        }
    }
    
    //MARK: - UITableViewCell override

    override func prepareForReuse() {
        super.prepareForReuse()

        movieTitleTextView.text = nil
        movieRankLabel.text = nil
        movieImageView.image = nil
    }
}
