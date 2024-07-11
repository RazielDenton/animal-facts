//
//  AnimalCategory.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

struct AnimalCategory: Codable, Hashable {

    let order: Int
    let title: String
    let description: String
    let image: String
    let animalFacts: [AnimalFact]?
    let status: CategoryStatus

    init(order: Int, title: String, description: String, image: String, animalFacts: [AnimalFact]?, status: CategoryStatus) {
        self.order = order
        self.title = title
        self.description = description
        self.image = image
        self.animalFacts = animalFacts
        self.status = status
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.order = try container.decode(Int.self, forKey: .order)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: .image)
        self.animalFacts = try container.decodeIfPresent([AnimalFact].self, forKey: .animalFacts)

        if self.animalFacts == nil {
            self.status = .comingSoon
        } else {
            self.status = try container.decode(CategoryStatus.self, forKey: .status)
        }
    }
}

// MARK: - Types

extension AnimalCategory {

    enum CategoryStatus: String, Codable {

        case paid
        case free
        case comingSoon
    }

    struct AnimalFact: Codable, Hashable {

        let fact: String
        let image: String
    }
}

// MARK: - CodingKeys

private extension AnimalCategory {

    enum CodingKeys: String, CodingKey {
        case order
        case title
        case description
        case image
        case animalFacts = "content"
        case status
    }
}
