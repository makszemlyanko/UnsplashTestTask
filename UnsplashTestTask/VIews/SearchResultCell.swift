//
//  SearchResultCell.swift
//  UnsplashTestTask
//
//  Created by Maks Kokos on 22.06.2022.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    let pictureImageView: UIImageView = {
        var iv = UIImageView()
        iv.image = UIImage(named: "IMG_6897.JPG")
        iv.clipsToBounds = true
        return iv
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pictureImageView)
        pictureImageView.fillSuperview(padding: .init(top: 50, left: 50, bottom: 50, right: 50))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
