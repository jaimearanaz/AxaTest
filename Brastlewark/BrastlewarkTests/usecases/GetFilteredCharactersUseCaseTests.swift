//
//  GetFilteredCharactersUseCaseTests.swift
//  AxaTestTests
//
//  Created by Jaime Aranaz on 1/6/22.
//

import Foundation
import XCTest
@testable import Brastlewark

class GetFilteredCharactersUseCaseTests: XCTestCase {

    func test_whenFiltersByAge_thenReturnsTheRightCharacters() async {
        
        let networkMocked = NetworkRepositoryMocked()
        let nonPersistentMocked = NonPersistentMocked()
        let cachedRepo = CachedRepository(networkRepository: networkMocked, nonPersistentRepository: nonPersistentMocked, useCache: true)
        let sut = DefaultGetFilteredCharactersUseCase(cachedRepository: cachedRepo, nonPersistentRepository: nonPersistentMocked)
        
        let filter = Filter(age: 5...7,
                            weight: DataForTesting.WideRange,
                            height: DataForTesting.WideRange,
                            hairColor: DataForTesting.HairValues,
                            profession: DataForTesting.ProfessionValues,
                            friends: DataForTesting.WideRange)

        nonPersistentMocked.charactersToReturn = DataForTesting.Characters
        nonPersistentMocked.filterActiveToReturn = filter
        
        do {
            let characterFiltered = try await sut.execute()
            
            XCTAssertEqual(characterFiltered.count, 3)
            XCTAssertEqual(characterFiltered[safe: 0]?.id, 1)
            XCTAssertEqual(characterFiltered[safe: 1]?.id, 2)
            XCTAssertEqual(characterFiltered[safe: 2]?.id, 3)

        } catch {
            XCTFail()
        }
    }
    
    func test_whenFiltersByWeight_thenReturnsTheRightCharacters() async {
        
        let networkMocked = NetworkRepositoryMocked()
        let nonPersistentMocked = NonPersistentMocked()
        let cachedRepo = CachedRepository(networkRepository: networkMocked, nonPersistentRepository: nonPersistentMocked, useCache: true)
        let sut = DefaultGetFilteredCharactersUseCase(cachedRepository: cachedRepo, nonPersistentRepository: nonPersistentMocked)
        
        let filter = Filter(age: DataForTesting.WideRange,
                            weight: 50...70,
                            height: DataForTesting.WideRange,
                            hairColor: DataForTesting.HairValues,
                            profession: DataForTesting.ProfessionValues,
                            friends: DataForTesting.WideRange)

        nonPersistentMocked.charactersToReturn = DataForTesting.Characters
        nonPersistentMocked.filterActiveToReturn = filter
        
        do {
            let characterFiltered = try await sut.execute()
            
            XCTAssertEqual(characterFiltered.count, 2)
            XCTAssertEqual(characterFiltered[safe: 0]?.id, 1)
            XCTAssertEqual(characterFiltered[safe: 1]?.id, 3)

        } catch {
            XCTFail()
        }
    }
    
    func test_whenFiltersByHeight_thenReturnsTheRightCharacters() async {
        
        let networkMocked = NetworkRepositoryMocked()
        let nonPersistentMocked = NonPersistentMocked()
        let cachedRepo = CachedRepository(networkRepository: networkMocked, nonPersistentRepository: nonPersistentMocked, useCache: true)
        let sut = DefaultGetFilteredCharactersUseCase(cachedRepository: cachedRepo, nonPersistentRepository: nonPersistentMocked)
        
        let filter = Filter(age: DataForTesting.WideRange,
                            weight: DataForTesting.WideRange,
                            height: 100...130,
                            hairColor: DataForTesting.HairValues,
                            profession: DataForTesting.ProfessionValues,
                            friends: DataForTesting.WideRange)

        nonPersistentMocked.charactersToReturn = DataForTesting.Characters
        nonPersistentMocked.filterActiveToReturn = filter
        
        do {
            let characterFiltered = try await sut.execute()
            
            XCTAssertEqual(characterFiltered.count, 2)
            XCTAssertEqual(characterFiltered[safe: 0]?.id, 0)
            XCTAssertEqual(characterFiltered[safe: 1]?.id, 1)

        } catch {
            XCTFail()
        }
    }
    
    func test_whenFiltersByHair_thenReturnsTheRightCharacters() async {
        
        let networkMocked = NetworkRepositoryMocked()
        let nonPersistentMocked = NonPersistentMocked()
        let cachedRepo = CachedRepository(networkRepository: networkMocked, nonPersistentRepository: nonPersistentMocked, useCache: true)
        let sut = DefaultGetFilteredCharactersUseCase(cachedRepository: cachedRepo, nonPersistentRepository: nonPersistentMocked)
        
        let filter = Filter(age: DataForTesting.WideRange,
                            weight: DataForTesting.WideRange,
                            height: DataForTesting.WideRange,
                            hairColor: ["Pink"],
                            profession: DataForTesting.ProfessionValues,
                            friends: DataForTesting.WideRange)

        nonPersistentMocked.charactersToReturn = DataForTesting.Characters
        nonPersistentMocked.filterActiveToReturn = filter
        
        do {
            let characterFiltered = try await sut.execute()
            
            XCTAssertEqual(characterFiltered.count, 1)
            XCTAssertEqual(characterFiltered[safe: 0]?.id, 2)

        } catch {
            XCTFail()
        }
    }
    
    func test_whenFiltersByProfession_thenReturnsTheRightCharacters() async {
        
        let networkMocked = NetworkRepositoryMocked()
        let nonPersistentMocked = NonPersistentMocked()
        let cachedRepo = CachedRepository(networkRepository: networkMocked, nonPersistentRepository: nonPersistentMocked, useCache: true)
        let sut = DefaultGetFilteredCharactersUseCase(cachedRepository: cachedRepo, nonPersistentRepository: nonPersistentMocked)
        
        let filter = Filter(age: DataForTesting.WideRange,
                            weight: DataForTesting.WideRange,
                            height: DataForTesting.WideRange,
                            hairColor: DataForTesting.HairValues,
                            profession: ["Wizard", "Miner"],
                            friends: DataForTesting.WideRange)

        nonPersistentMocked.charactersToReturn = DataForTesting.Characters
        nonPersistentMocked.filterActiveToReturn = filter
        
        do {
            let characterFiltered = try await sut.execute()
            
            XCTAssertEqual(characterFiltered.count, 2)
            XCTAssertEqual(characterFiltered[safe: 0]?.id, 0)
            XCTAssertEqual(characterFiltered[safe: 1]?.id, 2)

        } catch {
            XCTFail()
        }
    }
    
    func test_whenFiltersByFriends_thenReturnsTheRightCharacters() async {
        
        let networkMocked = NetworkRepositoryMocked()
        let nonPersistentMocked = NonPersistentMocked()
        let cachedRepo = CachedRepository(networkRepository: networkMocked, nonPersistentRepository: nonPersistentMocked, useCache: true)
        let sut = DefaultGetFilteredCharactersUseCase(cachedRepository: cachedRepo, nonPersistentRepository: nonPersistentMocked)
        
        let filter = Filter(age: DataForTesting.WideRange,
                            weight: DataForTesting.WideRange,
                            height: DataForTesting.WideRange,
                            hairColor: DataForTesting.HairValues,
                            profession: DataForTesting.ProfessionValues,
                            friends: 4...4)

        nonPersistentMocked.charactersToReturn = DataForTesting.Characters
        nonPersistentMocked.filterActiveToReturn = filter
        
        do {
            let characterFiltered = try await sut.execute()
            
            XCTAssertEqual(characterFiltered.count, 1)
            XCTAssertEqual(characterFiltered[safe: 0]?.id, 4)

        } catch {
            XCTFail()
        }
    }
}
