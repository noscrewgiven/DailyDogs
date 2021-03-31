//
//  StorageManager.swift
//  DailyDogs
//
//  Created by Ramona Cvelf on 31.03.21.
//

import Foundation

struct BreedPersistentModel: Codable {
    var name: String
    var subBreeds: [String]?
}

class StorageManager {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func save(breeds: [Breed]) {
        guard let url = makeURL(forFileNamed: "breeds.json") else {
            print("Failed to save breeds due to invalid file-url")
            return
        }
        
        var persistentBreeds: [BreedPersistentModel] = []
        for breed in breeds {
            var subBreedNames: [String] = []
            for subBreed in breed.subBreeds {
                subBreedNames.append(subBreed.name)
            }
            
            persistentBreeds.append(BreedPersistentModel(name: breed.name, subBreeds: subBreedNames))
        }
        
        do {
            let data = try JSONEncoder().encode(persistentBreeds)
            try data.write(to: url)
        } catch {
            print("Failed storing breeds to file with error \(error).")
        }
    }
    
    func load() -> [Breed]? {
        guard let url = makeURL(forFileNamed: "breeds.json") else {
            print("Failed to save breeds due to invalid file-url")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let persistentBreeds = try JSONDecoder().decode([BreedPersistentModel].self, from: data)
            
            var breeds: [Breed] = []
            for persistentBreed in persistentBreeds {
                var subBreeds: [Breed.SubBreed] = []
                
                if let persistentSubBreeds = persistentBreed.subBreeds {
                    for persistentSubBreed in persistentSubBreeds {
                        subBreeds.append(Breed.SubBreed(name: persistentSubBreed))
                    }
                }
                
                breeds.append(Breed(name: persistentBreed.name, subBreeds: subBreeds))
            }
            return breeds
        } catch {
            print("Failed loading breeds from file with error \(error).")
        }
        
        return nil
    }
    
    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
}
