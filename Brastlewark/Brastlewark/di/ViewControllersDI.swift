//
//  ViewControllersDI.swift
//  Brastlewark
//
//  Created by Jaime Aranaz on 13/6/22.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {

    @objc class func registerViewControllers() {
        
        defaultContainer.storyboardInitCompleted(GridViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(GridViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(CharacterDetailsViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(CharacterDetailsViewModel.self)
        }
        defaultContainer.storyboardInitCompleted(FilterViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(FilterViewModel.self)
        }
    }
}
