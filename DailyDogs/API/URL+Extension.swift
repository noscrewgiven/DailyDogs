//
//  URL+Extension.swift
//  DailyDogs
//
//  Created by Ramona Cvelf on 30.03.21.
//

import Foundation

extension URL {
    static func BreedsListAll() -> URL? {
        guard let url = URL(string: "https://dog.ceo/api/breeds/list/all") else {
            return nil
        }
        return url
    }
    
    static func randomImagesForBreed(name: String, subBreed: String?, count: Int) -> URL? {
        if let subBreed = subBreed {
            guard let url = URL(string: "https://dog.ceo/api/breed/\(name)/\(subBreed)/images/random/\(count)") else {
                return nil
            }
            
            return url
        } else {
            guard let url = URL(string: "https://dog.ceo/api/breed/\(name)/images/random/\(count)") else {
                return nil
            }
            return url
        }
    }
}
