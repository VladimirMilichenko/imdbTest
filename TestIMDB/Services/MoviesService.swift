//
//  MoviesServiceProtocol.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/18/22.
//

import Foundation

protocol MoviesServiceProtocol {
    func getMoviesFromApi(completion: @escaping (Result<[Movie], Error>) -> ())
    func getMoviesFromCache(completion: @escaping (Result<[Movie], Error>) -> ())
}

class MoviesService: MoviesServiceProtocol {
    func getMoviesFromApi(completion: @escaping (Result<[Movie], Error>) -> ()) {
        let path = "/API/Top250Movies"
        
        HttpRequestHelper.shared.imdbApiGetRequest(path: path) { result in
            switch result {
            case .success(let data):
                guard let moviesModel = try? JSONDecoder().decode(Movies.self, from: data) else {
                    completion(.failure(ResponseCustomError.decodeError))
                    return
                }
                
                completion(.success(moviesModel.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMoviesFromCache(completion: @escaping (Result<[Movie], Error>) -> ()) {
        
    }
}
