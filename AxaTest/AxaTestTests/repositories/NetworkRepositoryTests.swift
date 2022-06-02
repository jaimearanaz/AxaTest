//
//  NetworkRepositoryTests.swift
//  AxaTestTests
//
//  Created by Jaime Aranaz on 1/6/22.
//

import XCTest
import Combine
@testable import AxaTest

class NetworkRepositoryTests: XCTestCase {
    
    private var subscribers = Set<AnyCancellable>()
    
    func test_whenThereIsNoNetwork_thenReturnsNoNetworkError() {
        
        let networkStatusMocked = NetworkStatusMocked.self
        networkStatusMocked.isInternetAvailableToReturn = false
        let sut = NetworkRepository(baseUrl: "https://www.google.com", networkStatus: networkStatusMocked)
        
        let expectation = XCTestExpectation(description: "try network with no connectivity")
        var testError: NetworkErrors = .general

        sut.getCharacters()
            .sink { combineCompletion in
                
                switch combineCompletion {
                case .finished:
                    break
                case .failure(let error):
                    testError = error as! NetworkErrors
                    expectation.fulfill()
                    break
                }
                
            } receiveValue: { characters in
                XCTFail()
            }
            .store(in: &subscribers)
        
        wait(for: [expectation], timeout: 2)

        XCTAssertNotNil(testError)
        XCTAssertEqual(testError, .noNetwork)
    }
}
