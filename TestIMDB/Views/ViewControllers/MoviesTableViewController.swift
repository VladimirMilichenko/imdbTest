//
//  ViewController.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import UIKit
//TODO: Pull to refresh from online
class MoviesTableViewController: UITableViewController {
    private let moviesService = MoviesService()
    private var activityIndicatorView: UIActivityIndicatorView!
    
    lazy var viewModel: MoviesViewModel = {
//        return MoviesViewModel(moviesService: moviesService)
        return MoviesViewModel(moviesService: MoviesTestDataService())
    }()
    
    //MARK: - UITableViewController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView = UIActivityIndicatorView(frame: view.bounds)
        activityIndicatorView.style = .large
        
        tableView.backgroundView = activityIndicatorView
        
        self.updateMovies()
        
        viewModel.viewModelCompletion = { [weak self] error in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
                
                if let err = error {
                    self?.showAlertWithError(err)
                } else {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CharactersCountTableViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let viewModel = viewModel.getMovieeCellViewModel(at: indexPath)
            destinationVC.title = viewModel.title
            
            destinationVC.viewModel = CharactersCountViewModel(title: viewModel.title,
                                                               imageUrl: viewModel.imageUrl,
                                                               image: viewModel.image)
        }
    }
    
    //MARK: - Private methods
    
    private func updateMovies() {
        activityIndicatorView.startAnimating()
        viewModel.getMovies()
    }
    
    //MARK: - UITableViewDataSource override
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieCellViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            fatalError("MovieTableViewCell does not exist")
        }
                       
        let cellViewModel = viewModel.getMovieeCellViewModel(at: indexPath)
        cell.cellViewModel = cellViewModel
        
        return cell
    }
}

