//
//  SceneTransitionType.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

enum SceneTransitionType {
    case modal(UIModalPresentationStyle = .fullScreen, UIModalTransitionStyle = .coverVertical)
    case push
    case root
}
