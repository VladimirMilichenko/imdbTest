//
//  MoviesServiceProtocol.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import Foundation

protocol MoviesServiceProtocol {
    func getMoviesFromApi(completion: @escaping (Result<[Movie], Error>) -> ())
    func getMoviesFromCache(completion: @escaping (Result<[Movie], Error>) -> ())
}
