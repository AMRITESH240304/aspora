//
//  FavoriteView.swift
//  aspora
//
//  Created by Amritesh Kumar on 30/12/25.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = ImageDetailViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            if viewModel.favorites.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                    Text("No Favorites Yet")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.favorites, id: \.date) { apod in
                            NavigationLink(destination: ImageDetailView(apod: apod)) {
                                ZStack(alignment: .bottom) {
                                    RetryableImageView(urlString: apod.hdurl ?? apod.url)
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 250)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    
                                    VStack(alignment: .leading) {
                                        Text(apod.title)
                                            .font(.caption).bold()
                                            .foregroundStyle(.white)
                                            .lineLimit(2)
                                        Text(apod.date)
                                            .font(.caption2)
                                            .foregroundStyle(.white.opacity(0.9))
                                    }
                                    .padding(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.ultraThinMaterial)
                                }
                                .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 8)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Favorites")
                .background(Color(UIColor.systemBackground))
            }
        }
        .onAppear {
            viewModel.loadFavorites()
        }
    }
}

#Preview {
    FavoriteView()
}
