//
//  RepositoriesDI.swift
//  Brastlewark
//
//  Created by Jaime Aranaz on 13/6/22.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
 
    @objc class func registerRepositories() {
        
        defaultContainer.register(NetworkRepositoryProtocol.self) { _ in NetworkRepository(baseUrl: APIBaseURL.rawValue, networkStatus: NetworkStatus.self) }
        
        let nonPersistentRepository = NonPersistentRepository()
        defaultContainer.register(NonPersistentRepositoryProtocol.self) { _ in nonPersistentRepository }
        
        defaultContainer.register(CachedRepositoryProtocol.self) { resolver in
            CachedRepository(networkRepository: resolver.resolve(NetworkRepositoryProtocol.self),
                             nonPersistentRepository: resolver.resolve(NonPersistentRepositoryProtocol.self),
                             useCache: true)
        }
    }
}
