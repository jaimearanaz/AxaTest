//
//  BaseViewModel.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation

protocol BaseViewModelOutput {
    
    var errorMessage: Box<String> { get set }
    var isLoading: Box<Bool> { get set }
}

protocol BaseViewModelInput {
    
    func viewDidLoad()
    func viewDidAppear()
}

protocol BaseViewModelProtocol: BaseViewModelOutput, BaseViewModelInput {
 
}

class BaseViewModel: BaseViewModelProtocol {

    var errorMessage = Box("")
    var isLoading = Box(false)
    
    func viewDidLoad() { }
    
    func viewDidAppear() { }
}
