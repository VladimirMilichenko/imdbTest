//
//  MovieTableViewCellViewModel.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/18/22.
//

import UIKit

class MovieTableViewCellViewModel: ViewModel {
    var id: String
    var rank: String
    
    init(id: String, title: String, rank: String, imageUrl: URL) {
        self.id = id
        self.rank = rank
        
        super.init(title: title, imageUrl: imageUrl)
    }
}
