//
//  NetworkService.swift
//  testProjectAlturos
//
//  Created by Ramona Cvelf on 25.03.21.
//

import Foundation

enum ApiError: Error {
    case None
    case DecodingFailed
    case ApiCallFailed
}

class ApiService {
    private let networkClient = NetworkClient()
    
    func getAllBreeds(completion: @escaping (Result<[Breed], ApiError>) -> Void) {
        networkClient.get(endpoint: URL.BreedsListAll(), completion: { result in
            switch result {
            case .failure(_):
                print("BreedsListAll API Call failed")
                completion(.failure(ApiError.ApiCallFailed))
                
            case .success(let data):
                if let breeds = ApiDecoder.decodeDogBreeds(from: data) {
                    completion(.success(breeds))
                } else {
                    print("Failed to decode API-Call BreedsListAll")
                    completion(.failure(ApiError.DecodingFailed))
                }
            }
        })
    }
    
    func getImagesForAllBreedsAndSubBreeds(_ breedsIn: [Breed], count: Int, completion: @escaping (Result<[Breed], ApiError>) -> Void) {
        let group = DispatchGroup()
        var error = ApiError.None
        var breeds = breedsIn
        
        for (index, breed) in breeds.enumerated() {
            group.enter()
            getImagesForBreed(breed, count: count) { result in
                switch result {
                case .failure(let e):
                    // Capture first error which occurs
                    if error == ApiError.None {
                        error = e
                    }
                case .success(let breed):
                    breeds[index] = breed
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if error == ApiError.None {
                completion(.success(breeds))
            } else {
                // Call completion with first error occured
                completion(.failure(error))
            }
        }
    }
    
    // Fetch images for Breed and subBreeds
    func getImagesForBreed(_ breedIn: Breed, count: Int, completion: @escaping (Result<Breed, ApiError>) -> Void) {
        let group = DispatchGroup()
        var breed = breedIn
        var error = ApiError.None
        
        group.enter()
        getImagesForBreed(name: breed.name, subBreed: nil, count: count, completion: { result in
            switch result {
            case .failure(let e):
                // Capture first error which occurs
                if error == ApiError.None {
                    error = e
                }
                
            case .success(let images):
                breed.images = images
                breed.didLoadImagesFromApi = true
            }
            
            group.leave()
        })
        
        for (index, subBreed) in breed.subBreeds.enumerated() {
            group.enter()
            getImagesForBreed(name: breed.name, subBreed: subBreed.name, count: count, completion: { result in
                switch result {
                case .failure(let e):
                    // Capture first error which occurs
                    if error == ApiError.None {
                        error = e
                    }
                    
                case .success(let images):
                    breed.subBreeds[index].images = images
                }
                
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            if error == ApiError.None {
                completion(.success(breed))
            } else {
                // Call completion with first error occured
                completion(.failure(error))
            }
        }
    }

    func getImagesForBreed(name: String, subBreed: String?, count: Int, completion: @escaping (Result<[String], ApiError>) -> Void) {
        networkClient.get(endpoint: URL.randomImagesForBreed(name: name, subBreed: subBreed, count: count), completion: { result in
            switch result {
            case .failure(_):
                print("randomImagesForBreed API Call failed")
                completion(.failure(ApiError.ApiCallFailed))
                
            case .success(let data):
                if let images = ApiDecoder.decodeRandomImages(from: data) {
                    completion(.success(images))
                } else {
                    print("Failed to decode API-Call randomImagesForBreed with data: \(String(decoding: data, as: UTF8.self))")
                    completion(.failure(ApiError.DecodingFailed))
                }
            }
        })
    }
}
