//
//  DependencyInjection.swift
//  Brastlewark
//
//  Created by Jaime Aranaz on 13/6/22.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    @objc class func setup() {
        
        registerRepositories()
        registerUseCases()
        registerViewModels()
        registerViewControllers()
    }
}
