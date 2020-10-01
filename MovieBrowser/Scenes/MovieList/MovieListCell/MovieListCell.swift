//
//  MovieListCell.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 30.09.2020.
//

import UIKit
import SDWebImage

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        ratingLabel.text = nil
        releaseDateLabel.text = nil
        
        posterImageView.image = UIImage(named: "placeholder")
    }
    
    private func setupUI() {
        ratingView.layer.cornerRadius = ratingView.bounds.height / 2
        ratingView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 10
        posterImageView.layer.masksToBounds = true
    }
    
    func setupWithModel(_ movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = "\(movie.vote)"
        releaseDateLabel.text = movie.releaseDateDescription
    }
    
    func updatePosterWith(_ image: UIImage?) {
        posterImageView.image = image
    }
}
