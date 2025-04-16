//
//  AnimalCategoriesFeature.swift
//  AnimalFacts
//
//  Created by Viacheslav on 12.07.2024.
//

import ComposableArchitecture
import RealmSwift

@Reducer
struct AnimalCategoriesFeature {

    @Reducer(state: .equatable)
    enum Destination {
        case animalFactsScreen(AnimalFactsFeature)
        case errorAlert(AlertState<AnimalCategoriesFeature.Action.Alert>)
        case advertAlert(AlertState<AnimalCategoriesFeature.Action.Alert>)
        case comingSoonAlert(AlertState<AnimalCategoriesFeature.Action.Alert>)
    }

    @ObservableState
    struct State: Equatable {
        var isLoading = false
        var isShowingAdvertisement = false
        var animalCategories: [AnimalCategory] = []
        var selectedAnimalCategory: AnimalCategory?
        @Presents var destination: Destination.State?
    }

    enum Action {
        case loadAnimalCategories
        case refresh
        case animalFactsResponse(Result<[AnimalCategory], Error>)
        case animalCategoryTapped(category: AnimalCategory)
        case paidAnimalCategoryAdvertCompleted

        case destination(PresentationAction<Destination.Action>)

        enum Alert: Equatable {
            case showAdTapped
        }
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.animalFactsClient) var animalFactsClient
    @ObservedResults(
        AnimalCategory.self,
        sortDescriptor: SortDescriptor(keyPath: "order", ascending: true)
    ) var animalCategoryResults

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadAnimalCategories:
                state.isLoading = true
                state.animalCategories = Array(animalCategoryResults.sorted(by: \.order, ascending: true))
                return loadAnimalCategories()
            case .refresh:
                return loadAnimalCategories()
            case .animalFactsResponse(.success(let animalCategories)):
                state.isLoading = false
                state.animalCategories = animalCategories
                let realm = try? Realm()
                try? realm?.write {
                    realm?.add(animalCategories, update: .modified)
                }
                return .none
            case .animalFactsResponse(.failure(let error)):
                state.isLoading = false
                return showAlert(ofType: .error(error), &state)
            case .animalCategoryTapped(category: let animalCategory):
                state.selectedAnimalCategory = animalCategory
                switch animalCategory.status {
                case .free:
                    return showAnimalFactsScreen(&state)
                case .paid:
                    return showAlert(ofType: .advertisement, &state)
                case .comingSoon:
                    return showAlert(ofType: .comingSoon, &state)
                }
            case .destination(.presented(.advertAlert(.showAdTapped))):
                state.isShowingAdvertisement = true
                return .run { send in
                    try await self.clock.sleep(for: .seconds(2))
                    await send(.paidAnimalCategoryAdvertCompleted)
                }
            case .paidAnimalCategoryAdvertCompleted:
                state.isShowingAdvertisement = false
                return showAnimalFactsScreen(&state)
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

private extension AnimalCategoriesFeature {

    enum AlertType {
        case error(Error)
        case advertisement
        case comingSoon
    }

    func loadAnimalCategories() -> Effect<Action> {
        return .run { send in
            await send(
                .animalFactsResponse(Result { try await animalFactsClient.loadAnimalCategories() }),
                animation: .default
            )
        }
    }

    func showAlert(ofType type: AlertType, _ state: inout State) -> Effect<Action> {
        switch type {
        case .error(let error):
            state.destination = .errorAlert(
                AlertState {
                    TextState(error.localizedDescription)
                } actions: {
                    ButtonState {
                        TextState("Ok")
                    }
                }
            )
        case .advertisement:
            state.destination = .advertAlert(
                AlertState {
                    TextState("Watch Ad to continue")
                } actions: {
                    ButtonState() {
                        TextState("Cancel")
                    }
                    ButtonState(action: .showAdTapped) {
                        TextState("Show Ad")
                    }
                }
            )
        case .comingSoon:
            state.destination = .comingSoonAlert(
                AlertState {
                    TextState("Coming Soon")
                } actions: {
                    ButtonState {
                        TextState("Ok")
                    }
                }
            )
        }
        return .none
    }

    func showAnimalFactsScreen(_ state: inout State) -> Effect<Action> {
        state.destination = .animalFactsScreen(
            AnimalFactsFeature.State(
                animalFacts: Array(state.selectedAnimalCategory?.animalFacts ?? List<AnimalCategory.AnimalFact>())
            )
        )
        return .none
    }
}
