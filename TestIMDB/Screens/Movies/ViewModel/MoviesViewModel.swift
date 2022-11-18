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
            reloadTableView?()
        }
    }
    
    var reloadTableView: (() -> ())?
    
    private var moviesService: MoviesServiceProtocol
    
    //MARK: - Lifecycle
    
    init(moviesService: MoviesServiceProtocol) {
        self.moviesService = moviesService
    }
    
    //MARK: - Internal methods
    
    func getMoviesFromApi() {
        moviesService.getMoviesFromApi() { result in
            switch result {
            case .success(let movies):
                self.fetchMovies(Array(movies[0...9]))
            case .failure(let error):
                print(error.localizedDescription)
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
                                                            imageUrlPath: movie.imageUrlPath)
            
            vms.append(cellViewModel)
        }
        
        movieCellViewModels = vms
    }
}
