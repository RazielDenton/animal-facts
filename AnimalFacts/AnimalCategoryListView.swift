//
//  ContentView.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import SwiftUI
import ComposableArchitecture

struct AnimalCategoryListView: View {

    let store: StoreOf<AnimalFactsFeature>

    @State private var showAdvertAlert = false
    @State private var showingAdvertisement = false
    @State private var showComingSoonAlert = false
    @State private var showAnimalCategoryScreen = false
    @State private var selectedAnimalCategory: AnimalCategory?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                if store.isLoading {
                    ProgressView()
                } else {
                    if store.animalCategories.isEmpty {
                        Text("Sorry for the inconvenience")
                    } else {
                        animalCategoriesView
                    }
                }

                if showingAdvertisement {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    ProgressView().tint(.white)
                }
            }
            .navigationTitle("")
        }
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
                ForEach(store.animalCategories, id: \.order) { category in
                    Button {
                        selectedAnimalCategory = category
                        switch category.status {
                        case .paid:
                            showAdvertAlert.toggle()
                        case .free:
                            showAnimalCategoryScreen.toggle()
                        case .comingSoon:
                            showComingSoonAlert.toggle()
                        }
                    } label: {
                        AnimalCategoryView(animalCategory: category)
                    }
                }
            }
            .padding(.horizontal)
        }
        .alert("Watch Ad to continue", isPresented: $showAdvertAlert) {
            Button("Cancel", role: .cancel, action: { })
            Button("Show Ad") {
                withAnimation {
                    showingAdvertisement = true
                }
                Task {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    showingAdvertisement = false
                    showAnimalCategoryScreen = true
                }
            }
            .keyboardShortcut(.defaultAction)
        }
        .alert("Coming Soon", isPresented: $showComingSoonAlert) {
            Button("Ok", role: .cancel) { }
        }
        .navigationDestination(isPresented: $showAnimalCategoryScreen) {
            AnimalFactsView(animalFacts: selectedAnimalCategory?.animalFacts ?? [])
                .navigationTitle(selectedAnimalCategory?.title ?? "")
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
            initialState: AnimalFactsFeature.State(
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
            AnimalFactsFeature()
        }
    )
}
