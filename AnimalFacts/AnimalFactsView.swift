//
//  AnimalFactsView.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import SwiftUI

struct AnimalFactsView: View {

    @State private var selectedTab = 0

    let animalFacts: [AnimalCategory.AnimalFact]

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Array(animalFacts.enumerated()), id: \.offset) { index, animalFact in
                GeometryReader { geometryProxy in
                    AnimalFactView(animalFact: animalFact)
                        .frame(height: geometryProxy.size.height * 0.9)
                        .tag(index)
                }
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .overlay {
            navigationButtons
        }
        .background {
            Color.background.ignoresSafeArea()
        }
    }
}

// MARK: - Views

private extension AnimalFactsView {

    var navigationButtons: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    withAnimation {
                        if selectedTab == 1 {
                            selectedTab = animalFacts.count
                        } else {
                            selectedTab -= 1
                        }
                    }
                } label: {
                    Image(systemName: "arrow.left.circle")
                        .resizable()
                        .frame(width: UIDimensions.buttonSize, height: UIDimensions.buttonSize)
                        .foregroundStyle(.black.opacity(0.6))
                }
                Spacer()
                Button {
                    withAnimation {
                        if selectedTab == animalFacts.count {
                            selectedTab = 1
                        } else {
                            selectedTab += 1
                        }
                    }
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
    AnimalFactsView(animalFacts: [
        .init(fact: "A cat cannot see directly under its nose.", image: "https://cdn2.thecatapi.com/images/5op.jpg"),
        .init(fact: "When a cat drinks, its tongue - which has tiny barbs on it - scoops the liquid up backwards.", image: "https://cdn2.thecatapi.com/images/b8j.jpg"),
        .init(fact: "The cat's clavicle, or collarbone, does not connect with other bones but is buried in the muscles of the shoulder region. This lack of a functioning collarbone allows them to fit through any opening the size of their head.", image: "https://cdn2.thecatapi.com/images/bgr.jpg"),
        .init(fact: "In 1987, cats overtook dogs as the number one pet in America (about 50 million cats resided in 24 million homes in 1986). About 37% of American homes today have at least one cat.", image: "https://cdn2.thecatapi.com/images/chl.jpg"),
        .init(fact: "A cat named Dusty, aged 1 7, living in Bonham, Texas, USA, gave birth to her 420th kitten on June 23, 1952.", image: "https://cdn2.thecatapi.com/images/ck7.jpg")
    ])
}
