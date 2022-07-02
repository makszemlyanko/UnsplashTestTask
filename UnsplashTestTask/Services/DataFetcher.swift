//
//  DataFetcher.swift
//  UnsplashTestTask
//
//  Created by Maks Kokos on 01.07.2022.
//

import Foundation

class DataFetcher {
    
    var networkService = NetworkService()
    
    func fetchImages(searchTerm: String, complition: @escaping (SearchResult?) -> ()) {
        networkService.request(searchTerm: searchTerm) { (data, err) in
            if let error = err {
                print("Error: \(error.localizedDescription)")
                complition(nil)
            }
            
            let decode = self.decodeJSON(type: SearchResult.self, from: data)
            complition(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError{
            print("Failed to decode jsonNN", jsonError)
            return nil
        }
    }
    
}
