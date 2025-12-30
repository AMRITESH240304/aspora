//
//  NetworkManager.swift
//  aspora
//
//  Created by Amritesh Kumar on 29/12/25.
//

import Foundation
import Combine

final class NetworkManager: ObservableObject {
    func getAPOD() -> Future<APODResponse, Error> {
        Future { promise in
            let date = Date()
            let dateString = date.formatted(.iso8601.year().month().day())
            guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"],
                  !apiKey.isEmpty else {
                return
            }
            let apiURL = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&date=\(dateString)"
            let url = URL(string: apiURL)!
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let data = data else {
                    promise(.failure(URLError(.badServerResponse)))
                    return
                }
                
                Task{ @MainActor in
                    do {
                        let apod = try JSONDecoder().decode(APODResponse.self, from: data)
                        promise(.success(apod))
                    } catch {
                        promise(.failure(error))
                    }
                }
                
            }
            .resume()
        }
    }
    
    func loadAPODsbyDates(from date: String) -> Future<APODResponse, Error> {
        Future { promise in
            guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"],
                  !apiKey.isEmpty else {
                return
            }
            let apiURL = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&date=\(date)"
            let url = URL(string: apiURL)!
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let data = data else {
                    promise(.failure(URLError(.badServerResponse)))
                    return
                }
                
                Task{ @MainActor in
                    do {
                        let apod = try JSONDecoder().decode(APODResponse.self, from: data)
                        promise(.success(apod))
                    } catch {
                        promise(.failure(error))
                    }
                }
                
            }
            .resume()

        }
    }
    
    func loadMoreAPODs(from date: String) -> Future<[APODResponse], Error> {
        Future { promise in
            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let end = formatter.string(from: today)
            guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"],
                  !apiKey.isEmpty else {
                return
            }
            let apiURL = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&start_date=\(date)&end_date=\(end)"
            let url = URL(string: apiURL)!

            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                guard let data = data else {
                    promise(.failure(URLError(.badServerResponse)))
                    return
                }
                Task { @MainActor in
                    do {
                        let result = try JSONDecoder().decode([APODResponse].self, from: data)
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
