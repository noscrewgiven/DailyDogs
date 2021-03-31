//
//  ApiDecoder.swift
//  testProjectAlturos
//
//  Created by Ramona Cvelf on 30.03.21.
//

import Foundation

struct BreedsApi: Codable {
    var message: [String : [String]?]
}

struct RandomImagesApi: Codable {
    var message: [String]
    var status: String
}

class ApiDecoder {
    static func decodeDogBreeds(from apiCall: Data?) -> [Breed]? {
        guard let apiCall = apiCall else { return nil }
        
        if let decodedBreeds = try? JSONDecoder().decode(BreedsApi.self, from: apiCall) {
            var breeds = Array<Breed>()
            
            for (key, value) in decodedBreeds.message {
                var breed = Breed(name: key)
                
                if let subBreeds = value {
                    for subBreed in subBreeds {
                        breed.subBreeds.append(Breed.SubBreed(name: subBreed))
                    }
                }
                
                breeds.append(breed)
            }
            
            return breeds
        } else {
            return nil
        }
    }
    
    static func decodeRandomImages(from apiCall: Data?) -> [String]? {
        guard let apiCall = apiCall else { return nil }
        if let decodedImages = try? JSONDecoder().decode(RandomImagesApi.self, from: apiCall) {
            return decodedImages.message
        } else {
            return nil
        }
    }
}
