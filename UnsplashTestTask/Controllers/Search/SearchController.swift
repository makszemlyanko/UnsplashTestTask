//
//  SearchController.swift
//  UnsplashTestTask
//
//  Created by Maks Kokos on 21.06.2022.
//

import UIKit

class SearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var networkDataFetcher = DataFetcher()
    private var timer: Timer?
    
    private let searchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter a search term above"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var photos = [PhotoResult]()
    
    private var selectedImages = [UIImage]()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    fileprivate lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    fileprivate lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    fileprivate var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        updateNavButtonState()
        setupSearchBar()
        setupCollectionView()
        setupNavBarButtons()
        setupSpinner()
        
        collectionView.addSubview(searchTermLabel)
        searchTermLabel.fillSuperview(padding: .init(top: 150, left: 50, bottom: 0, right: 50))
    }
    
    fileprivate func updateNavButtonState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavButtonState()
    }
    
    // MARK: - Navigation Bar buttons
    
    @objc private func addBarButtonTapped() {
        print(#function)
        let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (phots, indexPath) -> [PhotoResult] in
            var mutablePhotos = phots
            let photo = photos[indexPath.item]
            mutablePhotos.append(photo)
            return mutablePhotos
        })
        
        let alertController = UIAlertController(title: "", message: "\(selectedPhotos!.count) photos will be added in album", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            let tabbar = self.tabBarController as! BaseTabBarController
            let navVC = tabbar.viewControllers?[1] as! UINavigationController
            let favoritesVC = navVC.topViewController as! FavoriteController
            
            favoritesVC.photos.append(contentsOf: selectedPhotos ?? [])
            favoritesVC.collectionView.reloadData()
            
            self.refresh()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        print(#function)
        
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
            
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    // MARK: - Setup UI elements
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }
    
    fileprivate func setupNavBarButtons() {
        navigationItem.rightBarButtonItems = [
            actionBarButtonItem,
            addBarButtonItem
        ]
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.cellId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
    }
    
    // MARK: - Setup collection items: data source, delegate
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchTermLabel.isHidden = photos.count != 0
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        updateNavButtonState()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.cellId, for: indexPath) as! SearchResultCell
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonState()
        let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCell
        guard let image = cell.photoImageView.image else { return }
        selectedImages.append(image)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonState()
        let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCell
        guard let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchRes) in
                guard let fetchedPhotos = searchRes else { return }
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
                self?.refresh()
            }
        })
    }


    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
