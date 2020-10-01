//
//  MovieListViewController.swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 29.09.2020.
//

import UIKit

class MovieListViewController: UIViewController, MovieListView {

    @IBOutlet weak var collectionView: UICollectionView!
    var configurator: MovieListConfigurator!
    var presenter: MovieListPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtton
        
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
        
        presenter.getMoviePosterForItemAt(indexPath: indexPath) { (imageData) in
            if let data = imageData, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.updatePosterWith(image)
                }
            }
        }
        
        return cell
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = (collectionView.bounds.width - 8) / 2
        return CGSize(width: size, height: 360)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        presenter.cancelDownloadPosterImageForItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(indexPath: indexPath)
    }
}
