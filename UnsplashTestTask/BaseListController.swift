//
//  BaseListController.swift
//  UnsplashTestTask
//
//  Created by Maks Kokos on 21.06.2022.
//

import UIKit

class BaseListController: UICollectionViewController {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
