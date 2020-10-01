//
//  TrailerView.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import UIKit
import youtube_ios_player_helper

protocol TrailerViewDelegate: class {
    func closeActionRequest()
}

class TrailerView: UIView {

    @IBOutlet weak var playerView: YTPlayerView!
    weak var delegate: TrailerViewDelegate?

    @IBAction func closeAction(_ sender: Any) {
        delegate?.closeActionRequest()
    }
    
    func loadTrailerForKey(_ key: String) {
        playerView.load(withVideoId: key)
    }
}
