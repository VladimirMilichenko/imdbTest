//
//  MoviesTestDataService.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import Foundation

class TestDataMoviesService: MoviesServiceProtocol {
    func getMovies(completion: @escaping (Result<[Movie], Error>) -> ()) {
        if let bundleURL = Bundle.main.url(forResource: "Movies", withExtension: "json"),
           let data = try? Data(contentsOf: bundleURL) {
            guard let moviesModel = try? JSONDecoder().decode(Movies.self, from: data) else {
                completion(.failure(ResponseCustomError.decodeError))
                return
            }
            
            completion(.success(moviesModel.items))
        } else {
            completion(.failure(ResponseCustomError.dataError))
        }
    }
}
