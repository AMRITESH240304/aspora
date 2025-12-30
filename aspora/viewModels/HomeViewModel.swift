//
//  HomeViewModel.swift
//  aspora
//
//  Created by Amritesh Kumar on 29/12/25.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var apod: APODResponse?
    @Published var moreAPODs: [APODResponse] = []
    @Published var apodByDate: APODResponse?
    @Published var errorMessage: String?
    @Published var showDateSheet = false
    @Published var showingDateDetail = false

    private let network = NetworkManager()
    private var cancellables = Set<AnyCancellable>()

    func load() {
        network.getAPOD()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    print(self!.errorMessage!)
                }
            } receiveValue: { [weak self] apod in
                self?.apod = apod
            }
            .store(in: &cancellables)
    }
    
    func fetchByDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = formatter.string(from: date)

        let minDate = formatter.date(from: "1995-06-16")!
        let maxDate = Date()

        if date < minDate {
            errorMessage = "Date before 1995-06-16 is not allowed"
            return
        }
        if date > maxDate {
            errorMessage = "Future date selection is not allowed"
            return
        }
        
        errorMessage = nil
        
        network.loadAPODsbyDates(from: selectedDate)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] apod in
                    self?.apodByDate = apod
                }
            )
            .store(in: &cancellables)
    }

    func loadMore() {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let start = Calendar.current.date(byAdding: .day, value: -5, to: today)!
        let startDate = formatter.string(from: start)

        network.loadMoreAPODs(from: startDate)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] list in
                    self?.moreAPODs = list
                }
            )
            .store(in: &cancellables)
    }
}
