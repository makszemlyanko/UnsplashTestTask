//
//  SearchController.swift
//  UnsplashTestTask
//
//  Created by Maks Kokos on 21.06.2022.
//

import UIKit

class SearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var networkService = NetworkService()
    
    fileprivate lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    fileprivate lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let cellId = "cellId"
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        setupSearchBar()
        setupCollectionView()
        setupNavBarButtons()
    }
    
    // MARK: - Navigation Bar buttons
    
    @objc private func addBarButtonTapped() {
        print(#function)
    }
    
    @objc private func actionBarButtonTapped() {
        print(#function)
    }
    
    // MARK: - Setup UI elements
    
    fileprivate func setupNavBarButtons() {
        navigationItem.rightBarButtonItems = [
            actionBarButtonItem,
            addBarButtonItem
        ]
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
    }
    
    // MARK: - Setup collection items
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        cell.backgroundColor = .systemPink
        return cell
    }
    
    //MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        networkService.request(searchTerm: searchText) { (_, _) in
            print(searchText)
        }
    }
    
    
}




