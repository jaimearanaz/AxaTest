//
//  BaseViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation

import Foundation
import UIKit

protocol BaseViewControllerProtocol {

    func localizeView()
    func customizeView()
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
        
    var baseViewModel: BaseViewModel?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        assertViewModel()
        localizeView()
        customizeView()
        binds()
        baseViewModel?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        baseViewModel?.viewDidAppear()
    }
    
    func localizeView() { }
    
    func customizeView() { }
    
    func binds() { }
    
    func showAlert(withMessage message: String) {
        
        let alert = UIAlertController(title: "ERROR_MESSAGE_TITLE".localized,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ERROR_MESSAGE_BUTTON".localized,
                                      style: .default,
                                      handler: nil))
        self.present(alert, animated: true)
    }
    
    private func assertViewModel() {
        assert(baseViewModel != nil, "base view model must be set in base view controller")
    }
}
