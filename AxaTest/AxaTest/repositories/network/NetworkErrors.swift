//
//  NetworkErrors.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import Foundation

enum NetworkErrors: Error {
    
    case general
    case noNetwork
    case timeout
    case wrongUrl
    case statusError(Int)
    case wrongJson
}

