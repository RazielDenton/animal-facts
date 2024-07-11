//
//  AnimalFactsController.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import Foundation

@MainActor
final class AnimalFactsController: ObservableObject {

    @Published private(set) var animalCategories: [AnimalCategory] = []
    @Published private(set) var isLoading: Bool = false

    private let contentLink: String = "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json"

    func loadAnimalCategories() {
        Task {
            guard let url = URL(string: contentLink) else { return }

            isLoading = true
            defer { isLoading = false }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                do {
                    let decodedResponse = try JSONDecoder().decode([AnimalCategory].self, from: data)
                    animalCategories = decodedResponse.sorted { $0.order < $1.order }
                } catch {
                    print("unsuccessful decode")
                }
            } catch {
                print("invalid data")
            }
        }
    }
}
