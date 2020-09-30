//
//  MovieListCell.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import UIKit

class MovieListCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        ratingView.layer.cornerRadius = ratingView.bounds.height / 2
        ratingView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 10
        posterImageView.layer.masksToBounds = true
    }
}
