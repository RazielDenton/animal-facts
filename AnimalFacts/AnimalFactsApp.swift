//
//  AnimalFactsApp.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct AnimalFactsApp: App {

    static let store = Store(initialState: AnimalFactsFeature.State()) {
        AnimalFactsFeature()
            ._printChanges()
    }

    var body: some Scene {
        WindowGroup {
            AnimalCategoryListView(store: AnimalFactsApp.store)
        }
    }
}
