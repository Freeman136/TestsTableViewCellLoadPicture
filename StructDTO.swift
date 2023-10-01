//
//  StructDTO.swift
//  CellNEw
//
//  Created by Andrew on 25.09.2023.
//

import Foundation

struct Cat: Codable {
    let id: String
    let url: String
    let width: Int
    let height: Int
    let breeds: [Breed]?
    let categories: [Category]?
    
    struct Breed: Codable {
        let id: String?
        let name: String?
        let temperament: String?
        let description: String?
    }
    
    struct Category: Codable {
        let id: Int?
        let name: String?
    }
}
