//
//  NetworkManager.swift
//  CellNEw
//
//  Created by Andrew on 25.09.2023.
//

import Foundation

enum Constants: String {
	case invalidURL = "invalidURL"
}

enum Endpoints: String {
	case defaultEndpoint = "https://api.thecatapi.com/v1/images/search?limit=10"
}


final class Network {
	
    static func getCats(str: String, completion: @escaping (Result<[Cat], Error>) -> Void) {
        
        guard let url = URL(string: str) else {
			completion(.failure(NSError(domain: Constants.invalidURL.rawValue, code: -1)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _ , error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "no data", code: -1)))
                return
            }
            
            do {
                let cat = try JSONDecoder().decode([Cat].self, from: data)
                completion(.success(cat))
                
            } catch {
                completion(.failure(error))
            }
        }
		
        task.resume()
    }
}
