//
//  AnimalCategory.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import Foundation
import RealmSwift

final class AnimalCategory: Object, ObjectKeyIdentifiable, Decodable {

    @Persisted(primaryKey: true) var order: Int
    @Persisted var title: String
    @Persisted var categoryDescription: String
    @Persisted var image: String
    @Persisted var animalFacts: RealmSwift.List<AnimalFact>
    @Persisted var status: CategoryStatus

    override init() {
        super.init()
    }

    convenience init(
        order: Int,
        title: String,
        categoryDescription: String,
        image: String,
        animalFacts: [AnimalFact],
        status: CategoryStatus
    ) {
        self.init()
        self.order = order
        self.title = title
        self.categoryDescription = description
        self.image = image
        self.animalFacts.append(objectsIn: animalFacts)
        self.status = status
    }

    init(from decoder: any Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.order = try container.decode(Int.self, forKey: .order)
        self.title = try container.decode(String.self, forKey: .title)
        self.categoryDescription = try container.decode(String.self, forKey: .categoryDescription)
        self.image = try container.decode(String.self, forKey: .image)
        let animalFacts = try container.decodeIfPresent(List<AnimalFact>.self, forKey: .animalFacts) ?? List<AnimalFact>()
        self.animalFacts = animalFacts

        if animalFacts.isEmpty {
            self.status = .comingSoon
        } else {
            self.status = try container.decode(CategoryStatus.self, forKey: .status)
        }
    }
}

// MARK: - Types

extension AnimalCategory {

    enum CategoryStatus: String, PersistableEnum, Decodable {

        case free
        case paid
        case comingSoon
    }

    @objc(AnimalFact) class AnimalFact: Object, ObjectKeyIdentifiable, Decodable {

        @Persisted var fact: String
        @Persisted var image: String
        @Persisted(originProperty: "animalFacts") var category: LinkingObjects<AnimalCategory>

        override init() {
            super.init()
        }

        convenience init(fact: String, image: String) {
            self.init()
            self.fact = fact
            self.image = image
        }
    }
}

// MARK: - CodingKeys

private extension AnimalCategory {

    enum CodingKeys: String, CodingKey {
        case order
        case title
        case categoryDescription = "description"
        case image
        case animalFacts = "content"
        case status
    }
}

private extension AnimalCategory.AnimalFact {

    enum CodingKeys: String, CodingKey {
        case fact
        case image
    }
}
