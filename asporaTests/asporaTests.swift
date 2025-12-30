//
//  asporaTests.swift
//  asporaTests
//
//  Created by Amritesh Kumar on 30/12/25.
//

import Testing
import Combine
import Foundation
@testable import aspora

struct asporaTests {

    @Test func testLoadAPODSuccess() async throws {
        let viewModel = await HomeViewModel()
        
        await viewModel.load()
        
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        #expect(viewModel.apod != nil)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func testFetchByDateValid() async throws {
        let viewModel = await HomeViewModel()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let validDate = dateFormatter.date(from: "2024-01-01")!
        
        await viewModel.fetchByDate(validDate)
        
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.apodByDate != nil)
    }
    
    @Test func testFetchByDateBeforeMinDate() async throws {
        let viewModel = await HomeViewModel()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let invalidDate = dateFormatter.date(from: "1995-06-15")!
            
        await viewModel.fetchByDate(invalidDate)
            
            #expect(viewModel.errorMessage == "Date before 1995-06-16 is not allowed")
            #expect(viewModel.apodByDate == nil)
        }
    
    @Test func testFetchByDateFutureDate() async throws {
        let viewModel = await HomeViewModel()
        
        let futureDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        await viewModel.fetchByDate(futureDate)
        
        #expect(viewModel.errorMessage == "Future date selection is not allowed")
        #expect(viewModel.apodByDate == nil)
    }
    
    @Test func testLoadMore() async throws {
        let viewModel = await HomeViewModel()
        
        await viewModel.loadMore()
        
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        #expect(viewModel.moreAPODs.isEmpty == false)
        #expect(viewModel.errorMessage == nil)
    }
}
