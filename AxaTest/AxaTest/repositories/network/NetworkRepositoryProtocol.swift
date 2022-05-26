//
//  NetworkRepositoryProtocol.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import Foundation
import Combine

protocol NetworkRepositoryProtocol {
    
    func getCharacters() -> AnyPublisher<[Character], Error>
}
