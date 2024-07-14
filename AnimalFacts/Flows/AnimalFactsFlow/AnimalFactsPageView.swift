//
//  AnimalFactsView.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import SwiftUI
import ComposableArchitecture

struct AnimalFactsPageView: View {

    @Perception.Bindable var store: StoreOf<AnimalFactsFeature>

    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.selectedTab) {
                ForEach(Array(store.animalFacts.enumerated()), id: \.offset) { index, animalFact in
                    GeometryReader { geometryProxy in
                        AnimalFactView(animalFact: animalFact)
                            .frame(height: geometryProxy.size.height * 0.9)
                            .tag(index)
                    }
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .background {
            Color.background.ignoresSafeArea()
        }
        .overlay {
            navigationButtons
        }
    }
}

// MARK: - Views

private extension AnimalFactsPageView {

    var navigationButtons: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    store.send(.backButtonTapped, animation: .default)
                } label: {
                    Image(systemName: "arrow.left.circle")
                        .resizable()
                        .frame(width: UIDimensions.buttonSize, height: UIDimensions.buttonSize)
                        .foregroundStyle(.black.opacity(0.6))
                }
                Spacer()
                Button {
                    store.send(.nextButtonTapped, animation: .default)
                } label: {
                    Image(systemName: "arrow.right.circle")
                        .resizable()
                        .frame(width: UIDimensions.buttonSize, height: UIDimensions.buttonSize)
                        .foregroundStyle(.black.opacity(0.6))
                }
            }
            .padding(.vertical, UIDimensions.layoutMarginHalf)
            .padding(.horizontal, UIDimensions.layoutMargin4x)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AnimalFactsPageView(store: Store(initialState: AnimalFactsFeature.State(
            animalFacts: [
                .init(
                    fact: "A cat cannot see directly under its nose.",
                    image: "https://cdn2.thecatapi.com/images/5op.jpg"),
                .init(
                    fact: "When a cat drinks, its tongue - which has tiny barbs on it - scoops the liquid up backwards.",
                    image: "https://cdn2.thecatapi.com/images/b8j.jpg"),
                .init(
                    fact: "The cat's clavicle, or collarbone, does not connect with other bones but is buried in the muscles of the shoulder region. This lack of a functioning collarbone allows them to fit through any opening the size of their head.",
                    image: "https://cdn2.thecatapi.com/images/bgr.jpg")
            ]
        )) { AnimalFactsFeature() })
    }
}
