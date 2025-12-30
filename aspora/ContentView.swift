//
//  ContentView.swift
//  aspora
//
//  Created by Amritesh Kumar on 29/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack(){
            HomeView()
                .navigationTitle("NASA Photo Gallery")
        }
    }
}

#Preview {
    ContentView()
}
