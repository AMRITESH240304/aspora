//
//  ImageDetailViewModel.swift
//  aspora
//
//  Created by Amritesh Kumar on 30/12/25.
//

import Foundation
import Combine

class ImageDetailViewModel: ObservableObject {
    @Published var favorites: [APODResponse] = []

    func loadFavorites() {
        let key = "favAPODs"
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([APODResponse].self, from: data) {
            favorites = decoded
        }
    }
    
    func toggleFavorite(_ apod: APODResponse) {
        let key = "favAPODs"
        var saved = favorites

        if let index = saved.firstIndex(where: { $0.date == apod.date }) {
            saved.remove(at: index)
        } else {
            saved.append(apod)
        }

        if let encoded = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
        favorites = saved
    }
    
    func isFavorite(_ apod: APODResponse) -> Bool {
        favorites.contains(where: { $0.date == apod.date })
    }
}
