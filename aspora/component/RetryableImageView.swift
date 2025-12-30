//
//  RetryableImageView.swift
//  aspora
//
//  Created by Amritesh Kumar on 30/12/25.
//

import SwiftUI

struct RetryableImageView: View {
    let urlString: String

    @State private var retryTrigger = UUID()
    @State private var hasFailed = false
    @State private var isLoading = true

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: urlString), transaction: .init(animation: .easeInOut)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .onAppear { startTimeout() }

                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .onAppear {
                            isLoading = false
                            hasFailed = false
                        }

                case .failure:
                    Color.gray.opacity(0.2)
                        .onAppear {
                            hasFailed = true
                            isLoading = false
                        }

                @unknown default:
                    EmptyView()
                }
            }
            .id(retryTrigger)

            if hasFailed {
                VStack {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(.title2)
                    Text("Retry")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                .onTapGesture {
                    isLoading = true
                    hasFailed = false
                    retryTrigger = UUID()
                }
            }
        }
    }

    func startTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            if isLoading {
                hasFailed = true
                isLoading = false
            }
        }
    }
}
