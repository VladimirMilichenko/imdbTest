//
//  MoviesServiceProtocol.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/18/22.
//

import Foundation

class MoviesService: MoviesServiceProtocol {
    func getMovies(completion: @escaping (Result<[Movie], Error>) -> ()) {
        let path = "/API/Top250Movies"
        
        //TODO: Remove helper, try to use 2 different services (online, offline)
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
