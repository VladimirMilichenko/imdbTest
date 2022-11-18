//
//  UIVIewController+Alert.swift
//  TestIMDB
//
//  Created by Vladimir Milichenko on 11/18/22.
//

import UIKit

extension UIViewController {
    func showAlertWithError(_ error: Error) {
        let dialogMessage = UIAlertController(title: NSLocalizedString("error", comment: ""),
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("ok_button_title", comment: ""),
                                     style: .default)
        
        dialogMessage.addAction(okAction)
        
        self.present(dialogMessage, animated: false)
    }
}
