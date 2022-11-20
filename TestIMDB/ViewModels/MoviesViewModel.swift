//
//  MoviesViewModel.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import Foundation

class MoviesViewModel {
    var movieCellViewModels = [MovieTableViewCellViewModel]() {
        didSet {
            viewModelCompletion?(nil)
        }
    }
    
    var viewModelCompletion: ((Error?) -> ())?
    
    private var moviesService: MoviesServiceProtocol
    private var needToCacheCheck: Bool = true
    
    private(set) var maxCount: Int
    
    //MARK: - Lifecycle
    
    init(moviesService: MoviesServiceProtocol, maxCount: Int = 10) {
        self.moviesService = moviesService
        self.maxCount = maxCount
    }
    
    //MARK: - Internal methods
    
    func getMovies() {
        if needToCacheCheck {
            needToCacheCheck = false
            
            if let movies = CoreDataManager.shared.loadMovies(), movies.count > 0 {
                self.fetchMovies(movies)
            } else {
                getMoviesFromApi()
            }
        } else {
            getMoviesFromApi()
        }
    }
    
    func getMovieCellViewModel(at indexPath: IndexPath) -> MovieTableViewCellViewModel {
        return movieCellViewModels[indexPath.row]
    }
    
    func getFilteredMovieCellViewModels(by searchText: String) -> [MovieTableViewCellViewModel] {
        let text = searchText.lowercased().trimmingCharacters(in: .whitespaces)
        
        return movieCellViewModels.filter {
            $0.title.lowercased().contains(text)
        }
    }
    
    func getFilteredMovieCellViewModel(by searchText: String, indexPath: IndexPath) -> MovieTableViewCellViewModel {
        let filtered = getFilteredMovieCellViewModels(by: searchText)
        return filtered[indexPath.row]
    }
    
    //MARK: - Private methods
    
    private func getMoviesFromApi() {
        moviesService.getMovies() { [weak self] result in
            switch result {
            case .success(let movies):
                self?.fetchMovies(movies, needToCache: true)
            case .failure(let error):
                self?.viewModelCompletion?(error)
            }
        }
    }
    
    private func fetchMovies(_ movies: [Movie], needToCache: Bool = false) {
        let count = movies.count <= maxCount ? movies.count : maxCount
        let range = 0..<count
        
        let moviesWithRange = Array(movies[range]).sorted(by: { (Int($0.rank) ?? 0) < (Int($1.rank) ?? 0) })
        
        if needToCache {
            CoreDataManager.shared.saveMovies(moviesWithRange)
        }
        
        var vms = [MovieTableViewCellViewModel]()
        
        for movie in moviesWithRange {
            let cellViewModel = MovieTableViewCellViewModel(id: movie.id,
                                                            title: movie.title,
                                                            rank: movie.rank,
                                                            imageUrl: movie.imageUrl)
            
            vms.append(cellViewModel)
        }
        
        movieCellViewModels = vms
    }
}
