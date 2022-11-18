//
//  MovieCell.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    //MARK: - Class methods
    
    class var identifier: String { return String(describing: self) }
    
    //MARK: - Internal methods
    
    var cellViewModel: MovieTableViewCellViewModel? {
        didSet {
            titleLabel.text = cellViewModel?.title
            
            let rankStr = NSLocalizedString("Rank", comment: "")
            let undefinedStr = NSLocalizedString("Undefined", comment: "")
            
            rankLabel.text = rankStr + ": " + (cellViewModel?.rank ?? undefinedStr)
        }
    }
    
    //MARK: - UITableViewCell override

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        titleLabel.text = nil
//        rankLabel.text = nil
    }
}
