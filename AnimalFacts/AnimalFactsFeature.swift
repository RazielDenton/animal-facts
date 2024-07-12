//
//  AnimalFactsLoader.swift
//  AnimalFacts
//
//  Created by Viacheslav on 12.07.2024.
//

import ComposableArchitecture

@Reducer
struct AnimalFactsFeature {

    @ObservableState
    struct State: Equatable {
        var isLoading = false
        var animalCategories: [AnimalCategory] = []
    }

    enum Action {
        case loadAnimalCategories
        case refresh
        case animalFactsResponse(Result<[AnimalCategory], Error>)
        case animalCategoryTapped(category: AnimalCategory)
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.animalFactsClient) var animalFactsClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadAnimalCategories:
                state.isLoading = true
                return .run { send in
                    await send(.animalFactsResponse(Result { try await animalFactsClient.loadAnimalCategories() }))
                }
            case .refresh:
                return .run { send in
                    await send(
                        .animalFactsResponse(Result { try await animalFactsClient.loadAnimalCategories() }),
                        animation: .default
                    )
                }
            case .animalFactsResponse(.success(let animalCategories)):
                state.isLoading = false
                state.animalCategories = animalCategories
                return .none
            case .animalFactsResponse(.failure(_)):
                state.isLoading = false
                return .none
            case .animalCategoryTapped(category: let category):
                return .run { send in
                    try await self.clock.sleep(for: .seconds(2))
                }
            }
        }
    }
}
