//
//  Breed.swift
//  testProjectAlturos
//
//  Created by Ramona Cvelf on 24.03.21.
//

import Foundation

struct Breed {
    var name: String
    var images: [String]?
    var subBreeds: [SubBreed] = []
    
    struct SubBreed {
        var name: String
        var images: [String]?
    }
}

class BreedModel {
    private let api = ApiService()
    var breeds: [Breed] = []
    
    func getBreedForName(_ name: String) -> Breed? {
        return breeds.first(where: { $0.name == name })
    }
}
