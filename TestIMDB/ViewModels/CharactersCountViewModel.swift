//
//  CharactersCountViewModel.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import UIKit

class CharactersCountViewModel: ViewModel {
    
    //MARK: Internal methods
    
    func titleCharactersOccurences() -> [(String, Int)]? {
        if title.count == 0 {
            return nil
        }
        
        return title
            .filter { !$0.isWhitespace }
            .lowercased()
            .reduce(into: [Character: Int]()) { dict, character in
                if let val = dict[character] {
                    dict[character] = val + 1
                } else {
                    dict[character] = 1
                }
            }.sorted(by: <)
            .map { (String($0), $1) }
    }
}
