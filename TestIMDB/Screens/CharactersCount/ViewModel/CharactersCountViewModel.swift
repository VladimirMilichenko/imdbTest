//
//  CharactersCountViewModel.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import Foundation

struct CharactersCountViewModel {
    var title: String
    
    //MARK: - Internal methods
    
    func titleCharactersOccurences() -> [Character: Int]? {
        if title.count == 0 {
            return nil
        }
        
        let processedTitle = title.filter { $0.isLetter }.lowercased()
        let setOfCharacters = NSOrderedSet(array: Array(processedTitle))
        
        var result = [Character: Int]()
        
        for uniqueCharacter in setOfCharacters {
            let character = uniqueCharacter as! Character
            let count = processedTitle.filter { $0 == character }.count
            result[character] = count
        }
        
        return result
    }
}
