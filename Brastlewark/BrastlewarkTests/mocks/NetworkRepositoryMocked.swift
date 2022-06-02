//
//  NetworkRepositoryMocked.swift
//  AxaTestTests
//
//  Created by Jaime Aranaz on 1/6/22.
//

import Combine
@testable import Brastlewark

class NetworkRepositoryMocked: NetworkRepositoryProtocol {
    
    var getCharactersCalled = false
    
    func getCharacters() -> AnyPublisher<[Character], Error> {
        
        getCharactersCalled = true
        return CurrentValueSubject([Character]()).eraseToAnyPublisher()
    }
}
