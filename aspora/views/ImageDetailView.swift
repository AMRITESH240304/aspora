//
//  ImageDetailView.swift
//  aspora
//
//  Created by Amritesh Kumar on 29/12/25.
//
import SwiftUI

struct ImageDetailView: View {
    let apod: APODResponse
    @State private var showFull = false
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        VStack {

            ZStack(alignment: .bottomLeading) {
                RetryableImageView(urlString: apod.hdurl ?? apod.url)
                    .frame(width: 360, height: 360)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .onTapGesture {
                        showFull = true
                    }

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
            .sheet(isPresented: $showFull) {
                ZStack {
                    RetryableImageView(urlString: apod.hdurl ?? apod.url)
                        .scaledToFit()
                        .scaleEffect(currentZoom + totalZoom)
                        .gesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    currentZoom = value.magnification - 1
                                }
                                .onEnded { value in
                                    totalZoom += currentZoom
                                    currentZoom = 0
                                }
                        )
                        .accessibilityZoomAction { action in
                            if action.direction == .zoomIn {
                                totalZoom += 1
                            } else {
                                totalZoom -= 1
                            }
                        }
                }
            }

            ScrollView {
                Text(apod.explanation)
                    .font(.body)
                    .padding()
            }
        }
    }
}

#Preview {
    ImageDetailView(
        apod: .init(
            copyright: "NASA",
            date: "2025-12-29",
            explanation: "This is the full explanation preview for detail screen.",
            hdurl: "https://apod.nasa.gov/apod/image/2512/Lrd_Webb_1080.jpg",
            media_type: "image",
            service_version: "v1",
            title: "Preview",
            url: ""
        )
    )
}
