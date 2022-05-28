//
//  BaseViewModel.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation

protocol BaseViewModelOutput {
    
}

protocol BaseViewModelInput {
    
    func viewDidLoad()
    func viewDidAppear()
}

protocol BaseViewModelProtocol: BaseViewModelOutput, BaseViewModelInput {
 
}

class BaseViewModel: BaseViewModelProtocol {

    
    
    func viewDidLoad() {

    }
    
    func viewDidAppear() {

    }
}
