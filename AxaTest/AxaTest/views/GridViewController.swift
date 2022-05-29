//
//  ViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import UIKit
import Combine

class GridViewController: BaseViewController {
    
    @IBOutlet weak var goToFilterBt: UIButton!

    var viewModel: GridViewModel? { didSet { baseViewModel = viewModel } }
    var navigationFlow: GridNavigationFlow?

    override func binds() {

        super.binds()
        viewModel?.isLoading.bind({ isLoading in
            
            switch isLoading {
            case true:
                self.startLoading()
            case false:
                self.stopLoading()
                break
            }
        })
        
        viewModel?.errorMessage.bind({ errorMessage in
            DispatchQueue.main.async {
                self.showAlert(withMessage: errorMessage)
            }
        })
        
        viewModel?.characters.bind({ characters in
            print("characters \(characters.count)")
        })
        
        viewModel?.transitionTo.bind({ transitionTo in
            self.performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        })
    }
    
    @IBAction func didSelectFilter() {
        viewModel?.didSelectFilter()
    }
    
    @IBAction func didSelectReset() {
        viewModel?.didSelectReset()
    }
    
    @IBAction func didSelectCharacter() {
        viewModel?.didSelectCharacter(id: 1)
    }
    
    func startLoading() {
        print("startLoading")
    }
    
    func stopLoading() {
        print("stopLoading")
    }
}
