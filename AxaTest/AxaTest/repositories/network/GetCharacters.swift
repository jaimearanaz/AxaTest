//
//  GetCharacters.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import Foundation
import Combine

extension NetworkRepository {
    
    func getCharacters() -> AnyPublisher<[Character], Error> {
        
        guard let url = URL(string: url) else {
            return Fail(error: NetworkErrors.wrongUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .mapError { error -> NetworkErrors in
                if error.errorCode == -1001 {
                    return .timeout
                } else {
                    return .general
                }
            }
            .retry(retries)
            .tryMap { (data, response) -> City in
                
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkErrors.general
                }
                
                if response.statusCode == 200 {
                    let decoder = JSONDecoder()
                    
                    if let city = try? decoder.decode(City.self, from: data) {
                        return city
                    } else {
                        throw NetworkErrors.wrongJson
                    }
                } else {
                    throw NetworkErrors.statusError(response.statusCode)
                }
            }
            .map { $0.brastlewark }
            .eraseToAnyPublisher()
    }
}
