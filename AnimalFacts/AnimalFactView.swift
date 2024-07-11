//
//  AnimalFactView.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import SwiftUI

struct AnimalFactView: View {

    let animalFact: AnimalCategory.AnimalFact

    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                Color.white
                ScrollView {
                    VStack(spacing: UIDimensions.layoutMargin) {
                        animalFactImage
                            .frame(maxWidth: geometryProxy.size.width - UIDimensions.layoutMargin4x)
                        Text(animalFact.fact)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    .padding(UIDimensions.layoutMargin2x)
                }
            }
        }
        .clipShape(.rect(cornerRadius: UIDimensions.defaultCornerRadius))
        .shadow(radius: 5, y: 5)
        .padding(UIDimensions.layoutMargin2x)
    }
}

// MARK: - Views

private extension AnimalFactView {

    var animalFactImage: some View {
        AsyncImage(url: URL(string: animalFact.image)) { phase in
            VStack {
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AnimalFactView(animalFact: .init(
            fact: "The cat's clavicle, or collarbone, does not connect with other bones but is buried in the muscles of the shoulder region. This lack of a functioning collarbone allows them to fit through any opening the size of their head. The cat's clavicle, or collarbone, does not connect with other bones but is buried in the muscles of the shoulder region. This lack of a functioning collarbone allows them to fit through any opening the size of their head. The cat's clavicle, or collarbone, does not connect with other bones but is buried in the muscles of the shoulder region. This lack of a functioning collarbone allows them to fit through any opening the size of their head. The cat's clavicle, or collarbone, does not connect with other bones but is buried in the muscles of the shoulder region. This lack of a functioning collarbone allows them to fit through any opening the size of their head.",
            image: "https://cdn2.thecatapi.com/images/5op.jpg"
        ))
        .navigationTitle("Cats 🐈")
        .background { Color.background.ignoresSafeArea() }
    }
}
