//
//  ApiURL.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 2/6/22.
//

import Foundation

#if PRE
var APIBaseURL: ApiEnvironments = .pre
#elseif DEV
var APIBaseURL: ApiEnvironments = .dev
#else
var APIBaseURL: ApiEnvironments = .pro
#endif

enum ApiEnvironments: String {
    
    case pro
    case pre
    case dev
    
    var rawValue: String {
        get {
            switch self {
            case .pro:
                return "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
            case .pre:
                return "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
            case .dev:
                return "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
            }
        }
    }
    
    static func current() -> String {
        return APIBaseURL.rawValue
    }
}
