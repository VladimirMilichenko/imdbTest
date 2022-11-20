//
//  CharactersCountTableViewController.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import UIKit

class CharactersCountTableViewController: UITableViewController {
    
    //MARK: IBOutlet
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    private let cellReuseIdentifier = "CharactersCountTableViewCell"
    
    var viewModel: CharactersCountViewModel?
    
    private var charactersOccurencies: [(String, Int)]?
    private var imageRequest: URLSessionTask?
    
    //MARK: - UIViewController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
       
        if let image = viewModel?.image {
            headerImageView.image = image
        } else if let viewModel = self.viewModel {
            activityIndicatorView.startAnimating()
            
            imageRequest = viewModel.loadImage() { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.headerImageView.image = viewModel.image
                        self?.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
        
        charactersOccurencies = viewModel?.titleCharactersOccurences()
        
        tableView.reloadData()
    }
    
    
    //MARK: - UIViewController override
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        imageRequest?.cancel()
    }
    
    //MARK: - UITableViewDataSource override
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.titleCharactersOccurences()?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        
        var content = cell.defaultContentConfiguration()
        
        let (character, count) = charactersOccurencies![indexPath.row]
        
        content.text = character
        content.secondaryText = String(count)
        
        cell.contentConfiguration = content
        
        return cell
    }
}

//MARK: - UINavigationControllerDelegate

extension CharactersCountTableViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
}

//MARK: - UIGestureRecognizerDelegate

extension CharactersCountTableViewController: UIGestureRecognizerDelegate {
    //To prevent bug on backswipe gesture (this happen, after custom animation added).
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
