//
//  FavoriteView.swift
//  aspora
//
//  Created by Amritesh Kumar on 30/12/25.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = ImageDetailViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.favorites.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray)
                    Text("No Favorites Yet")
                        .font(.title2)
                        .foregroundStyle(.gray)
                }
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
                                            .foregroundStyle(.white)
                                    }
                                    .padding(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.ultraThinMaterial)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Favorites")
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
