//
//  HttpClient.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import Foundation

final class HttpRequestHelper {
    static let shared = HttpRequestHelper()
    
    private let scheme = "https"
    private let host = "imdb-api.com"
    private let queryApiKeyParameterArr = [URLQueryItem(name: "apiKey", value: "k_e14w1h3a")]
    
    //MARK: - Internal methods
    
    func imdbApiGetRequest(path: String,
                           params: [String: String] = ["": ""],
                           completion: @escaping (Result<Data, Error>) -> ()) {
        var queryComponents = URLComponents()
        queryComponents.path = path
        queryComponents.scheme = scheme
        queryComponents.host = host
        
        if params.keys.count > 0 {
            let paramsQueryItems = params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            
            queryComponents.queryItems = queryApiKeyParameterArr + paramsQueryItems
        } else {
            queryComponents.queryItems = queryApiKeyParameterArr
        }
        
        var request = URLRequest(url: queryComponents.url!)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode else {
                let customError = ResponseCustomError.requestFailed
                completion(.failure(customError))
                return
            }
            
            guard let responseData = data else {
                let customError = ResponseCustomError.dataError
                completion(.failure(customError))
                return
            }
            
            completion(.success(responseData))
        }.resume()
    }
}
