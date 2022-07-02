//
//  SearchResult.swift
//  UnsplashTestTask
//
//  Created by Maks Kokos on 22.06.2022.
//

import Foundation

struct SearchResult: Decodable {
    let total: Int
    let results: [PhotoResult]
}

struct PhotoResult: Decodable {
    let width: Int
    let height: Int
    let urls: [UrlKind.RawValue: String]
    
    enum UrlKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
