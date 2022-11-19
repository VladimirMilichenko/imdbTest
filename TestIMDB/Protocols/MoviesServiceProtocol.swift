//
//  MoviesServiceProtocol.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import Foundation

protocol MoviesServiceProtocol {
    func getMovies(completion: @escaping (Result<[Movie], Error>) -> ())
}
