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
        VStack {
            Text(animalFactsController.animalCategories.first?.title ?? "Hello, world!")
        }
        .padding()
        .task {
            animalFactsController.loadAnimalCategories()
        }
    }
}

#Preview {
    AnimalCategoryListView()
}
