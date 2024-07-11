//
//  AnimalCategoryView.swift
//  AnimalFacts
//
//  Created by Viacheslav on 11.07.2024.
//

import SwiftUI

private extension CGFloat {
    static let animalCategoryHeight: CGFloat = 125
}

struct AnimalCategoryView: View {

    let animalCategory: AnimalCategory

    var body: some View {
        ZStack {
            Color.white
            animalCategoryCardView
        }
        .frame(height: .animalCategoryHeight)
        .clipShape(.rect(cornerRadius: UIDimensions.defaultCornerRadius))
        .shadow(radius: 5, y: 5)
    }
}

// MARK: - Views

private extension AnimalCategoryView {

    var animalCategoryCardView: some View {
        GeometryReader { geometryProxy in
            HStack(spacing: UIDimensions.layoutMargin) {
                animalCategoryImage
                    .frame(
                        maxWidth: geometryProxy.size.width * 0.35,
                        maxHeight: geometryProxy.size.height - UIDimensions.layoutMargin2x
                    )
                    .clipped()
                VStack(alignment: .leading) {
                    Text(animalCategory.title)
                        .font(.headline)
                        .lineLimit(1)
                    Text(animalCategory.description)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    if animalCategory.status == .paid {
                        Text("\(Image(systemName: "lock.fill")) Premium")
                            .foregroundStyle(Color.blue)
                            .font(.title3)
                    }
                }
                Spacer()
            }
            .padding(UIDimensions.layoutMargin)
        }
    }

    var animalCategoryImage: some View {
        AsyncImage(url: URL(string: animalCategory.image)) { phase in
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
    AnimalCategoryView(animalCategory: .init(
        order: 1,
        title: "Cats 🐈",
        description: "Different facts about cats",
        image: "https://images6.alphacoders.com/337/337780.jpg",
        content: nil,
        status: .paid
    ))
}
