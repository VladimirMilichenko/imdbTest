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
    
    //MARK: - Lifecycle
    
    init(moviesService: MoviesServiceProtocol) {
        self.moviesService = moviesService
    }
    
    //MARK: - Internal methods
    
    func getMovies() {
        moviesService.getMoviesFromApi() { [weak self] result in
            switch result {
            case .success(let movies):
                let range = 0...9
                if movies.count >= range.count {
                    self?.fetchMovies(Array(movies[range]))
                }
            case .failure(let error):
                self?.viewModelCompletion?(error)
            }
        }
    }
    
    func getMovieeCellViewModel(at indexPath: IndexPath) -> MovieTableViewCellViewModel {
        return movieCellViewModels[indexPath.row]
    }
    
    //MARK: - Private methods
    
    private func fetchMovies(_ movies: [Movie]) {
        var vms = [MovieTableViewCellViewModel]()
        
        for movie in movies {
            let cellViewModel = MovieTableViewCellViewModel(id: movie.id,
                                                            title: movie.title,
                                                            rank: movie.rank,
                                                            imageUrl: movie.imageUrl)
            
            vms.append(cellViewModel)
        }
        
        movieCellViewModels = vms
    }
}
