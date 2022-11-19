//
//  CharactersCountViewController.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/19/22.
//

import UIKit

class CharactersCountViewController: UIViewController {
    @IBOutlet weak var resultTextView: UITextView!
    
    var viewModel: CharactersCountViewModel?
    
    //MARK: UIViewController override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewModel, let charactersOccurences = viewModel.titleCharactersOccurences() {
            let title = "\(viewModel.title)\n"
            let mappedResult = charactersOccurences.sorted(by: <).map { "'\($0)' : \($1)" }.joined(separator: "\n")
            
            resultTextView.text = title + mappedResult
        } else {
            resultTextView.text = NSLocalizedString("title_error", comment: "")
        }
    }
}
