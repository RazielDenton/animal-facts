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
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                ForEach(animalFactsController.animalCategories, id: \.order) { category in
                    AnimalCategoryView(animalCategory: category)
                }
            }
            .padding()
        }
        .task {
            animalFactsController.loadAnimalCategories()
        }
    }
}

#Preview {
    AnimalCategoryListView()
}
