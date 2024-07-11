//
//  ContentView.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import SwiftUI

struct AnimalCategoryListView: View {

    @StateObject private var animalFactsController: AnimalFactsController = .init()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()

                if animalFactsController.isLoading {
                    ProgressView()
                } else {
                    if animalFactsController.animalCategories.isEmpty {
                        Text("Sorry for the inconvenience")
                    } else {
                        animalCategoriesView
                    }
                }
            }
        }
        .task {
            animalFactsController.loadAnimalCategories()
        }
    }
}

// MARK: - Views

private extension AnimalCategoryListView {

    var animalCategoriesView: some View {
        ScrollView {
            LazyVStack {
                ForEach(animalFactsController.animalCategories, id: \.order) { category in
                    NavigationLink {
                        AnimalFactsView(animalFacts: category.animalFacts ?? [])
                            .navigationTitle(category.title)
                    } label: {
                        AnimalCategoryView(animalCategory: category)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview

#Preview {
    AnimalCategoryListView()
}
