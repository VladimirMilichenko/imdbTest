//
//  MoviesService.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import Foundation

protocol MoviesService {
    func getMovies(completion: @escaping (Result<[Movie], Error>) -> ())
}
