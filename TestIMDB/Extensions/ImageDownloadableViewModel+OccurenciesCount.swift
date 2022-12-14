//
//  ImageDownloadableViewModel+OccurenciesCount.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/21/22.
//

import Foundation

extension ImageDownloadableViewModel {
    func titleCharactersOccurences() -> [(String, Int)]? {
        if title.count == 0 {
            return nil
        }
        
        return title
            .filter { !$0.isWhitespace }
            .lowercased()
            .reduce(into: [Character: Int]()) {
                if let val = $0[$1] {
                    $0[$1] = val + 1
                } else {
                    $0[$1] = 1
                }
            }.sorted(by: <)
            .map { (String($0), $1) }
    }
}
