//
//  NetworkRepository.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import Foundation

class NetworkRepository: NetworkRepositoryProtocol {
    
    var url: String
    var retries: Int
    
    internal init(baseUrl: String, retries: Int = 3) {
        
        self.url = baseUrl
        self.retries = retries
    }
}
