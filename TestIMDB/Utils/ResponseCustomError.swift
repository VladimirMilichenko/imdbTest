//
//  CustomResponseError.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/18/22.
//

import Foundation

enum ResponseCustomError: Error {
    case requestFailed
    case dataError
    case decodeError
    case imageError
    case unknown
}

extension ResponseCustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requestFailed:
            return "HTTP IMDB request failed."
        case .dataError:
            return "Couldn't retrieve data from response."
        case .decodeError:
            return "Couldn't decode JSON from response."
        case .imageError:
            return "Couldn't retrieve UIImage from response data."
        default:
            return nil
        }
    }
}
