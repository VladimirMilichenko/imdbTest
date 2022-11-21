//
//  ViewController.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/17/22.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    private var activityIndicatorView: UIActivityIndicatorView!
    private var searchController: UISearchController!
    
    lazy var viewModel: MoviesViewModel = {
        return MoviesViewModel(moviesService: ApiMoviesService())
//        return MoviesViewModel(moviesService: TestDataMoviesService())
    }()
    
    var isFiltering: Bool {
        let isSearchBarEmpty = searchController.searchBar.text?.isEmpty ?? true
        return searchController.isActive && !isSearchBarEmpty
    }
    
    //MARK: - UITableViewController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView = UIActivityIndicatorView(frame: view.bounds)
        activityIndicatorView.style = .large
        activityIndicatorView.hidesWhenStopped = true
        
        tableView.backgroundView = activityIndicatorView
        
        viewModel.delegate = self
        
        self.updateMovies(useCache: true)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search_placeholder", comment: "")
        
        navigationItem.searchController = searchController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CharactersCountTableViewController {
            let viewModel = cellViewModel(at: tableView.indexPathForSelectedRow!)
            destinationVC.title = viewModel.title
            
            destinationVC.viewModel = ImageDownloadableViewModel(title: viewModel.title,
                                                                 imageUrl: viewModel.imageUrl,
                                                                 image: viewModel.image)
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func refreshControlAction(_ sender: UIRefreshControl) {
        if !activityIndicatorView.isAnimating {
            self.updateMovies()
        }
    }
    
    //MARK: - Private methods
    
    private func updateMovies(useCache: Bool = false) {
        activityIndicatorView.startAnimating()
        viewModel.getMovies(needToCacheCheck: useCache)
    }
    
    private func cellViewModel(at indexPath: IndexPath) -> MovieTableViewCellViewModel {
        return isFiltering ? viewModel.getFilteredMovieCellViewModel(by: searchController.searchBar.text!,
                                                                     indexPath: indexPath)
                           : viewModel.getMovieCellViewModel(at: indexPath)
    }
    
    //MARK: - UITableViewDataSource override
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel.getFilteredMovieCellViewModels(by: searchController.searchBar.text!).count
        } else {
            return viewModel.movieCellViewModels.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier,
                                                       for: indexPath) as? MovieTableViewCell else {
            fatalError("MovieTableViewCell does not exist")
        }
        
        cell.cellViewModel = cellViewModel(at: indexPath)
        
        return cell
    }
}

//MARK: - MoviesViewModelDelegate

extension MoviesTableViewController: MoviesViewModelDelegate {
    func viewModelMoviesDidUpdated(_ sender: MoviesViewModel, error: Error?) {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            
            if let _ = self.refreshControl?.isRefreshing {
                self.refreshControl?.endRefreshing()
            }
            
            if let err = error {
                self.showAlertWithError(err)
            } else {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - UISearchResultsUpdating

extension MoviesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}
