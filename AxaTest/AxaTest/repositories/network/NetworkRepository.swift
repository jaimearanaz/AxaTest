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
    var networkStatus: NetworkStatusProtocol.Type
    
    internal init(baseUrl: String, retries: Int = 3, networkStatus: NetworkStatusProtocol.Type) {
        
        self.url = baseUrl
        self.retries = retries
        self.networkStatus = networkStatus
    }
}
