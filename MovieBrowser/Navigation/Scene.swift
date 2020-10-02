//
//  Scene.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import Foundation

enum Scene {
    case movieDetails(Movie)
    case movieList(isFavoriteList: Bool)
}
