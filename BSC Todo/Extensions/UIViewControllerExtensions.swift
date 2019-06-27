//
//  ErrorViewExtensions.swift
//  BSC Todo
//
//  Created by Lukas Sedlak on 26/06/2019.
//  Copyright © 2019 Lukas Sedlak. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlertController(title: String, error: Error?) {
        var errorMessage = "Unknown Error"
        if let error = error {
            errorMessage = error.localizedDescription
        }
        
        let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
