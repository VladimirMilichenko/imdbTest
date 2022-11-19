//
//  MoviesTestDataService.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import Foundation

class MoviesTestDataService: MoviesServiceProtocol {
    func getMoviesFromApi(completion: @escaping (Result<[Movie], Error>) -> ()) {
        completion(getMoviesFromJson())
    }
    
    func getMoviesFromCache(completion: @escaping (Result<[Movie], Error>) -> ()) {
        completion(getMoviesFromJson())
    }
    
    private func getMoviesFromJson() -> Result<[Movie], Error> {
        if let bundleURL = Bundle.main.url(forResource: "Movies", withExtension: "json"),
           let data = try? Data(contentsOf: bundleURL) {
            guard let moviesModel = try? JSONDecoder().decode(Movies.self, from: data) else {
                return .failure(ResponseCustomError.decodeError)
            }
            
            return .success(moviesModel.items)
        } else {
            return .failure(ResponseCustomError.dataError)
        }
    }
}
