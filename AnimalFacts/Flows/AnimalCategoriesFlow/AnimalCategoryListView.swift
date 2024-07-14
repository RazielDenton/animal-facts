//
//  ContentView.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import SwiftUI
import ComposableArchitecture

struct AnimalCategoryListView: View {

    @Perception.Bindable var store: StoreOf<AnimalCategoriesFeature>

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                WithPerceptionTracking {
                    if store.isLoading {
                        ProgressView()
                    } else {
                        if store.animalCategories.isEmpty {
                            Text("Sorry for the inconvenience")
                                .alert($store.scope(state: \.destination?.errorAlert, action: \.destination.errorAlert))
                        } else {
                            animalCategoriesView
                        }
                    }

                    if store.isShowingAdvertisement {
                        Color.black.opacity(0.5).ignoresSafeArea()
                        ProgressView().tint(.white)
                    }
                }
            }
            .navigationTitle("")
        }
        .tint(.black)
        .task {
            store.send(.loadAnimalCategories)
        }
    }
}

// MARK: - Views

private extension AnimalCategoryListView {

    var animalCategoriesView: some View {
        ScrollView {
            LazyVStack(spacing: UIDimensions.layoutMargin2x) {
                ForEach(store.animalCategories, id: \.order) { animalCategory in
                    Button {
                        store.send(.animalCategoryTapped(category: animalCategory))
                    } label: {
                        AnimalCategoryView(animalCategory: animalCategory)
                    }
                }
            }
            .padding(.horizontal)
        }
        .alert($store.scope(state: \.destination?.advertAlert, action: \.destination.advertAlert))
        .alert($store.scope(state: \.destination?.comingSoonAlert, action: \.destination.comingSoonAlert))
        .navigationDestination(
            item: $store.scope(state: \.destination?.animalFactsScreen, action: \.destination.animalFactsScreen)
        ) { showAnimalFactsStore in
            AnimalFactsPageView(store: showAnimalFactsStore)
                .navigationTitle(store.selectedAnimalCategory?.title ?? "")
        }
        .refreshable {
            store.send(.refresh)
        }
    }
}

// MARK: - Preview

#Preview {
    AnimalCategoryListView(
        store: Store(
            initialState: AnimalCategoriesFeature.State(
                animalCategories: [
                    .init(
                        order: 1,
                        title: "Cats 🐈",
                        description: "Different facts about cats",
                        image: "https://images6.alphacoders.com/337/337780.jpg",
                        animalFacts: nil,
                        status: .comingSoon
                    )
                ]
            )
        ) {
            AnimalCategoriesFeature()
        }
    )
}
