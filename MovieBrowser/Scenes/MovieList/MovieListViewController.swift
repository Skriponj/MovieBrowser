//
//  MovieListViewController.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

class MovieListViewController: UIViewController, MovieListView {

    @IBOutlet weak var collectionView: UICollectionView!
    var configurator = AppMovieListConfigurator()
    var presenter: MovieListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(movieListViewController: self)
        presenter.viewDidLoad()
        setupCollectionView()
        registerCells()
    }
    
    func showApiError(title: String?, message: String?) {
        showAlert(title: title, message: message)
    }
    
    func refreshMovieList() {
        collectionView.reloadData()
    }
    
    func updateMoviePoster(imageData: Data?, forItemAt indexPath: IndexPath) {
        guard let data = imageData,
              let image = UIImage(data: data) else {
            return
        }
        
        DispatchQueue.main.async {
            if let cell = self.collectionView.cellForItem(at: indexPath) as? MovieListCell {
                cell.updatePosterWith(image)
            }
        }
    }
}

private extension MovieListViewController {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func registerCells() {
        let movieCellId = String(describing: MovieListCell.self)
        let nib = UINib(nibName: movieCellId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: movieCellId)
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieCellId = String(describing: MovieListCell.self)
        let movie = presenter.movies[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellId, for: indexPath) as! MovieListCell
        cell.setupWithModel(movie)
        
        presenter.getMoviePosterForItemAt(indexPath: indexPath)
        
        return cell
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = (collectionView.bounds.width - 8) / 2
        return CGSize(width: size, height: 360)
    }
}
