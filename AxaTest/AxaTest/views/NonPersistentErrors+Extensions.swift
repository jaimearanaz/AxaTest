//
//  NonPersistentErrors+Extensions.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

extension NonPersistentErrors: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .noData:
            return "NON_PERSISTENT_ERROR_NO_DATA".localized
        }
    }
}
