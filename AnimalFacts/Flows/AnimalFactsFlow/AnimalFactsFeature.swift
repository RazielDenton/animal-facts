//
//  AnimalFactsFeature.swift
//  AnimalFacts
//
//  Created by Viacheslav on 12.07.2024.
//

import ComposableArchitecture

@Reducer
struct AnimalFactsFeature {

    @ObservableState
    struct State: Equatable, Hashable {
        var selectedTab: Int = 0
        let animalFacts: [AnimalCategory.AnimalFact]
    }

    enum Action: BindableAction {
        case backButtonTapped
        case nextButtonTapped
        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                if state.selectedTab == 0 {
                    state.selectedTab = state.animalFacts.count - 1
                } else {
                    state.selectedTab -= 1
                }
                return .none
            case .nextButtonTapped:
                if state.selectedTab == state.animalFacts.count - 1 {
                    state.selectedTab = 0
                } else {
                    state.selectedTab += 1
                }
                return .none
            case .binding:
                return .none
            }
        }
    }
}
