//
//  AnimalFactsClient.swift
//  AnimalFacts
//
//  Created by Viacheslav on 12.07.2024.
//

import Foundation
import ComposableArchitecture

struct AnimalFactsClient {
    var loadAnimalCategories: () async throws -> [AnimalCategory]
}

extension DependencyValues {
    var animalFactsClient: AnimalFactsClient {
        get { self[AnimalFactsClient.self] }
        set { self[AnimalFactsClient.self] = newValue }
    }
}

extension AnimalFactsClient: DependencyKey {

    static let liveValue = Self {
        guard
            let url = URL(string: "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json")
        else { throw NetworkAPIError.invalidURL }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode([AnimalCategory].self, from: data)

        return decodedResponse.sorted { $0.order < $1.order }
    }
}
