//
//  CachedRepositoryTests.swift
//  AxaTestTests
//
//  Created by Jaime Aranaz on 1/6/22.
//

import XCTest
import Combine
@testable import AxaTest

class CachedRepositoryTests: XCTestCase {
    
    func test_whenCharactersNotInCache_andCacheIsEnabled_thenRequestFromNetWork() async {
        
        let network = NetworkRepositoryMocked()
        let nonPersistent = NonPersistentMocked()
        let sut = CachedRepository(networkRepository: network, nonPersistentRepository: nonPersistent, useCache: true)
        
        nonPersistent.charactersToReturn = nil
        
        do {
            _ = try await sut.getCharacters()
        } catch {
            XCTFail()
        }
        
        XCTAssertEqual(network.getCharactersCalled, true)
    }
    
    func test_whenCharactersInCache_andCacheIsEnabled_thenReturnCache() async {
        
        let network = NetworkRepositoryMocked()
        let nonPersistent = NonPersistentMocked()
        let sut = CachedRepository(networkRepository: network, nonPersistentRepository: nonPersistent, useCache: true)
        
        nonPersistent.charactersToReturn = [Character]()
        
        do {
            _ = try await sut.getCharacters()
        } catch {
            XCTFail()
        }
        
        XCTAssertEqual(nonPersistent.getSavedCharactersCalled, true)
        XCTAssertEqual(network.getCharactersCalled, false)
    }
    
    func test_whenCharactersNotInCache_andCacheIsNotEnabled_thenRequestFromNetWork() async {
    
        let network = NetworkRepositoryMocked()
        let nonPersistent = NonPersistentMocked()
        let sut = CachedRepository(networkRepository: network, nonPersistentRepository: nonPersistent, useCache: false)
        
        nonPersistent.charactersToReturn = nil
        
        do {
            _ = try await sut.getCharacters()
        } catch {
            XCTFail()
        }
        
        XCTAssertEqual(network.getCharactersCalled, true)
    }
    
    func test_whenCharactersInCache_andCacheIsNotEnabled_thenRequestFromNetwork() async {
        
        let network = NetworkRepositoryMocked()
        let nonPersistent = NonPersistentMocked()
        let sut = CachedRepository(networkRepository: network, nonPersistentRepository: nonPersistent, useCache: false)
        
        nonPersistent.charactersToReturn = [Character]()
        
        do {
            _ = try await sut.getCharacters()
        } catch {
            XCTFail()
        }
        
        XCTAssertEqual(nonPersistent.getSavedCharactersCalled, false)
        XCTAssertEqual(network.getCharactersCalled, true)
    }
    
    func test_whenGetsCharactesFromNetwork_thenSavesAvailableFilterValues() async {
     
        NetworkStatusMocked.isInternetAvailableToReturn = true
        let network = NetworkRepository(baseUrl: "https://www.google.es", networkStatus: NetworkStatusMocked.self)
        let nonPersistent = NonPersistentMocked()
        let sut = CachedRepository(networkRepository: network, nonPersistentRepository: nonPersistent, useCache: true)
        
        nonPersistent.charactersToReturn = DataForTesting.Characters
        HTTPResponseMocked().setJsonResponse(fromFile: DataForTesting.CharactersJSONfile)
        
        do {
            _ = try await sut.getCharacters()
        } catch {
            XCTFail()
        }
        
        do {
            let filterValues = try await sut.getFilterValues()
            let filterValuesExpected = Filter(age: 3...10,
                                              weight: 34...82,
                                              height: 65...125,
                                              hairColor: DataForTesting.HairValues,
                                              profession: DataForTesting.ProfessionValues,
                                              friends: 0...4)
            XCTAssertEqual(filterValues, filterValuesExpected)
        } catch {
            XCTFail()
        }
    }
}
