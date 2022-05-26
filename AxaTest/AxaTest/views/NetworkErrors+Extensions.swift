//
//  NetworkErrors+Extensions.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import Foundation

extension NetworkErrors: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .general:
            return "NETWORK_ERROR_GENERAL".localized
        case .noNetwork:
            return "NETWORK_ERROR_NO_NETWORL".localized
        case .timeout:
            return "NETWORK_ERROR_TIMEOUT".localized
        case .wrongUrl:
            return "NETWORK_ERROR_URL".localized
        case .statusError(_):
            return "NETWORK_ERROR_STATUS".localized
        case .wrongJson:
            return "NETWORK_ERROR_JSON".localized
        }
    }
}
