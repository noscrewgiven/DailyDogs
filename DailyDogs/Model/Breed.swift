//
//  Breed.swift
//  testProjectAlturos
//
//  Created by Ramona Cvelf on 24.03.21.
//

import Foundation

struct Breed: Hashable {
    static func == (lhs: Breed, rhs: Breed) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var didLoadImagesFromApi: Bool = false
    var name: String
    var images: [String]?
    var subBreeds: [SubBreed] = []
    
    struct SubBreed {
        var name: String
        var images: [String]?
    }
    
    private let id = UUID()
}

class BreedModel {
    private let api = ApiService()
    private let persistentStorage = StorageManager()
    var breeds: [Breed] = []
    
    init() {
        if let persistentBreeds = persistentStorage.load() {
            breeds = persistentBreeds
        }
    }
    
    func getBreedByName(_ name: String) -> Breed? {
        return breeds.first(where: { $0.name == name })
    }
    
    func loadImagesForBreedsAndSubBreeds(count: Int, completion: @escaping () -> Void) {
        api.getImagesForAllBreedsAndSubBreeds(self.breeds, count: count, completion: { result in
            switch result {
            case .failure(let e):
                print("Failed loading Breeds from API with \(e)")
            
            case .success(let breeds):
                self.breeds = breeds
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        })
    }
    
    func loadBreedsFromApi(completion: @escaping () -> Void) {
        api.getAllBreeds(completion: { result in
            switch result {
            case .failure(let e):
                print("Failed loading Breeds from API with \(e)")
                
            case .success(let breeds):
                self.breeds = breeds
                self.persistentStorage.save(breeds: self.breeds)
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        })
    }
}
