//
//  UIViewController+FromStoryboard.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import UIKit

extension UIViewController {
    
    class func fromStoryboard() -> Self {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        return controller as! Self
    }
}
