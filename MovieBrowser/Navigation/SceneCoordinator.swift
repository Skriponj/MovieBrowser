//
//  SceneCoordinator.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

class SceneCoordinator: SceneCoordinatorType {
    
    private (set) var window: UIWindow
    private var currentViewController: UIViewController
    
    init(window: UIWindow) {
        self.window = window
        currentViewController = UIViewController()
    }
    
    private func actualViewController(for controller: UIViewController) -> UIViewController {
        if let navController = controller as? UINavigationController,
           let firstController = navController.viewControllers.first {
            return firstController
        } else {
            return controller
        }
    }
    
    func transition(to scene: Scene, transitionType: SceneTransitionType) {
        let controller = scene.viewController()
        
        switch transitionType {
        case .modal(let presentationStyle, let transitionStyle):
            controller.modalPresentationStyle = presentationStyle
            controller.modalTransitionStyle = transitionStyle
            
            currentViewController.present(controller, animated: true, completion: nil)
            
        case .push:
            guard let navController = currentViewController.navigationController else {
                fatalError("Can't make push operation without navigation controller")
            }
            navController.pushViewController(controller, animated: true)
            
        case .root:
            window.rootViewController = controller
        }
        
        currentViewController = actualViewController(for: controller)
    }
    
    func pop(animated: Bool) {
        if let presenting = currentViewController.presentingViewController {
            presenting.dismiss(animated: animated) {
                self.currentViewController = self.actualViewController(for: presenting)
            }
        } else if let navController = currentViewController.navigationController {
            guard navController.popViewController(animated: animated) != nil,
                  let lastViewController = navController.viewControllers.last else {
                fatalError("Can't navigate back from \(currentViewController)")
            }
            currentViewController = actualViewController(for: lastViewController)
        } else {
            fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
    }
}
