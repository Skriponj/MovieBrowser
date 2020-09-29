//
//  SceneCoordinatorType.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

protocol SceneCoordinatorType: class {
    func transition(to scene: Scene, transitionType: SceneTransitionType)
    func pop(animated: Bool)
}
