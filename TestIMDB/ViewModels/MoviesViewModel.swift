//
//  MoviesViewModel.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import Foundation

protocol MoviesViewModelDelegate: AnyObject {
    func viewModelMoviesDidUpdated(_ sender: MoviesViewModel, error: Error?)
}

class MoviesViewModel {
    weak var delegate: MoviesViewModelDelegate?
    
    static let defaultMaxCount = 10
    
    var movieCellViewModels = [MovieTableViewCellViewModel]() {
        didSet {
            delegate?.viewModelMoviesDidUpdated(self, error: nil)
        }
    }
    
    private(set) var moviesService: MoviesService
    private(set) var maxCount: Int
    
    //MARK: - Lifecycle
    
    init(moviesService: MoviesService, maxCount: Int = defaultMaxCount) {
        self.moviesService = moviesService
        self.maxCount = maxCount
    }
    
    //MARK: - Internal methods
    
    func getMovies(needToCacheCheck: Bool = false) {
        if needToCacheCheck {
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
        moviesService.getMovies() { result in
            switch result {
            case .success(let movies):
                self.fetchMovies(movies, needToCache: true)
            case .failure(let error):
                self.delegate?.viewModelMoviesDidUpdated(self, error: error)
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
        
        let vms = moviesWithRange.map {
            MovieTableViewCellViewModel(id: $0.id,
                                        title: $0.title,
                                        rank: $0.rank,
                                        imageUrl: $0.imageUrl)
        }
        
        movieCellViewModels = vms
    }
}
