//
//  ContentView.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import SwiftUI

struct AnimalCategoryListView: View {

    @StateObject private var animalFactsController: AnimalFactsController = .init()
    @State private var isLoading = true
    @State private var showAdvertAlert = false
    @State private var showingAdvertisement = false
    @State private var showComingSoonAlert = false
    @State private var showAnimalCategoryScreen = false
    @State private var selectedAnimalCategory: AnimalCategory?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                if isLoading {
                    ProgressView()
                } else {
                    if animalFactsController.animalCategories.isEmpty {
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
            await animalFactsController.loadAnimalCategories()
            isLoading = false
        }
    }
}

// MARK: - Views

private extension AnimalCategoryListView {

    var animalCategoriesView: some View {
        ScrollView {
            LazyVStack(spacing: UIDimensions.layoutMargin2x) {
                ForEach(animalFactsController.animalCategories, id: \.order) { category in
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
            await animalFactsController.loadAnimalCategories()
        }
    }
}

// MARK: - Preview

#Preview {
    AnimalCategoryListView()
}
