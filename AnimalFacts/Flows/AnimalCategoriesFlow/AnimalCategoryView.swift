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
            animalCategoryCardView.opacity(animalCategory.status == .comingSoon ? 0.6 : 1.0)
            if animalCategory.status == .comingSoon {
                comingSoonView
            }
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
                        .foregroundStyle(.black)
                        .lineLimit(1)
                    Text(animalCategory.categoryDescription)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    if animalCategory.status == .paid {
                        Text("\(Image(systemName: "lock.fill")) Premium")
                            .foregroundStyle(Color.blue)
                            .font(.body)
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
                        .imageScale(.large)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }

    var comingSoonView: some View {
        HStack {
            Spacer()
            Image(.comingSoon)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .animalCategoryHeight)
                .rotationEffect(.degrees(-15))
                .padding(.vertical, UIDimensions.layoutMargin)
        }
    }
}

// MARK: - Preview

#Preview {
    AnimalCategoryView(animalCategory: .init(
        order: 1,
        title: "Cats 🐈",
        categoryDescription: "Different facts about cats Different facts about cats Different facts about cats Different facts about cats Different facts about cats Different facts about cats Different facts about cats Different facts about cats",
        image: "https://images6.alphacoders.com/337/337780.jpg",
        animalFacts: [],
        status: .comingSoon
    ))
}
