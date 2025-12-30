//
//  HomeView.swift
//  aspora
//
//  Created by Amritesh Kumar on 29/12/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var expanded = false
    @State private var showingDateDetail = false
    @State private var showingFavorites = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {

            if let apod = viewModel.apod {
                ZStack(alignment: .bottomLeading) {
                    RetryableImageView(urlString: apod.hdurl ?? apod.url)
                    .frame(maxWidth: 360, maxHeight: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1), radius: 8)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(apod.title)
                            .font(.title3).bold()
                            .foregroundStyle(.white)

                        Text(apod.date)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.9))

                        if let copy = apod.copyright {
                            Text("© \(copy)")
                                .font(.footnote)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .padding(14)
                }
                .padding(.horizontal)
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(apod.explanation)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineLimit(expanded ? nil : 4)
                            .animation(.easeInOut, value: expanded)

                        Button(action: { expanded.toggle() }) {
                            Text(expanded ? "Show Less" : "Read More")
                                .font(.footnote).bold()
                                .foregroundStyle(.blue)
                        }
                    }
                    .padding(.horizontal, 18)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(viewModel.moreAPODs, id: \.date) { item in
                            NavigationLink(destination: ImageDetailView(apod: item)) {
                                
                                ZStack(alignment: .bottom) {
                                    RetryableImageView(urlString: item.hdurl ?? item.url)
                                        .frame(width: 140, height: 140)
                                        .clipShape(RoundedRectangle(cornerRadius: 18))
                                        .shadow(color: .black.opacity(colorScheme == .dark ? 0.2 : 0.08), radius: 6)
                                    
                                    VStack {
                                        Spacer()
                                        VStack {
                                            Text(item.title)
                                                .font(.caption2).bold()
                                                .foregroundStyle(.white)
                                                .lineLimit(1)

                                            Text(item.date)
                                                .font(.caption2)
                                                .foregroundStyle(.white.opacity(0.9))
                                        }
                                        .padding(8)
                                    }
                                    .frame(width: 140, height: 140)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                }
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundStyle(.red)
                    .padding()
            } else {
                ProgressView("Fetching NASA APOD...")
                    .padding(.top, 40)
            }
        }
        .background(Color(UIColor.systemBackground))
        .onAppear {
            if viewModel.apod != nil { return }
            viewModel.load()
            viewModel.loadMore()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Select Date") {
                    viewModel.showDateSheet = true
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showingFavorites = true
                } label: {
                    Image(systemName: "heart.text.square")
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $showingFavorites) {
            FavoriteView()
        }
        .sheet(isPresented: $viewModel.showDateSheet) {
            DatePickerSheet(viewModel: viewModel)
        }
        .navigationDestination(isPresented: $viewModel.showingDateDetail) {
            if let apod = viewModel.apodByDate {
                ImageDetailView(apod: apod)
            }
        }
    }
}

#Preview {
    HomeView()
}
