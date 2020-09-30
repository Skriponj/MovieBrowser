//
//  UIViewController+Alert.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import UIKit

protocol Notifiable where Self: UIViewController {
    func showAlert(title: String?, message: String?)
}

extension Notifiable {
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController: Notifiable { }
