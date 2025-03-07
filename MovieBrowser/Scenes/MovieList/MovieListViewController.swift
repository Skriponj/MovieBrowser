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
        toggleActivityIndicator(enable: true)
        presenter.viewDidLoad()
        setupCollectionView()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    @objc func reload() {
        toggleActivityIndicator(enable: true)
        presenter.getMovieList()
    }
    
    func showApiError(title: String?, message: String?) {
        showAlert(title: title, message: message)
    }
    
    func refreshMovieList() {
        toggleActivityIndicator(enable: false)
        collectionView.refreshControl?.endRefreshing()
        collectionView.reloadData()
    }
    
    func addItemsForNextPageAt(indexPaths: [IndexPath]) {
        toggleActivityIndicator(enable: false)
        collectionView.insertItems(at: indexPaths)
    }
}

private extension MovieListViewController {
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func registerCells() {
        let movieCellId = String(describing: MovieListCell.self)
        let nib = UINib(nibName: movieCellId, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: movieCellId)
    }
    
    func toggleActivityIndicator(enable: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = enable
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
        
        var itemSize: CGSize
        
        let collectionSize = collectionView.bounds.size
        if collectionSize.height > collectionSize.width {
            itemSize = CGSize(width: (collectionView.bounds.width - 8) / 2, height: 360)
        } else {
            itemSize = CGSize(width: (collectionView.bounds.width - 8) / 4, height: collectionSize.height)
        }
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        presenter.cancelDownloadPosterImageForItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.loadNextPageIfNeeded(lastItemIndex: indexPath.item)
    }
}
