//
//  FavoriteController.swift
//  UnsplashTestTask
//
//  Created by Maks Kokos on 21.06.2022.
//

import UIKit

class FavoriteController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    var photos = [PhotoResult]()
    
    private var searchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't add photos yet"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var trashBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: nil)
    }()
    
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(FavoritesCell.self, forCellWithReuseIdentifier: FavoritesCell.cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        collectionView.addSubview(searchTermLabel)
        searchTermLabel.fillSuperview(padding: .init(top: 200, left: 80, bottom: 0, right: 80))
        
        setupNavigationBar()
    }
    
    // MARK: - UI Elements
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = trashBarButtonItem
        trashBarButtonItem.isEnabled = false
    }
    
    // MARK: - Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchTermLabel.isHidden = photos.count != 0
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCell.cellId, for: indexPath) as! FavoritesCell
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        return cell
    }
    
    // MARK: - Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/3 - 1, height: width/3 - 1)
    }
    
}



