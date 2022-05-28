//
//  FilterViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation
import UIKit

class FilterViewController: BaseViewController {
    
    @IBOutlet weak var resetBt: UIButton!
    @IBOutlet weak var applyBt: UIButton!

    var viewModel: FilterViewModel? { didSet { baseViewModel = viewModel } }

    override func binds() {

        viewModel?.transitionTo.bind({ transitionTo in
            switch transitionTo {
            case .none:
                break
            case .dismiss:
                self.dismiss(animated: true)
            }
        })
        
        viewModel?.filterValues.bind({ filterValues in
            
        })
        
        viewModel?.activeFilter.bind({ activeFilter in
            
        })
    }
    
    @IBAction func didSelectReset() {
        viewModel?.didSelectReset()
    }
    
    @IBAction func didSelectApply() {
        viewModel?.didSelectApplyFilter(Filter())
    }
}
