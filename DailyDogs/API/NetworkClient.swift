//
//  NetworkClient.swift
//  DailyDogs
//
//  Created by Ramona Cvelf on 25.03.21.
//

import Foundation

class NetworkClient {
    func get(endpoint: URL?, completion: @escaping ((Result<Data, Error>) -> Void)) {
        guard let endpoint = endpoint else {
            print("Invalid Endpoint given")
            return
        }
        
        let request = URLRequest(url: endpoint)
        
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
