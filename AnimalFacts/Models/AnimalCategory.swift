//
//  AnimalCategory.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

struct AnimalCategory: Codable {

    let order: Int
    let title: String
    let description: String
    let image: String
    let content: [AnimalFact]?
    let status: CategoryStatus
}

// MARK: - Types

extension AnimalCategory {

    enum CategoryStatus: String, Codable {

        case paid
        case free
    }

    struct AnimalFact: Codable, Hashable {

        let fact: String
        let image: String
    }
}
