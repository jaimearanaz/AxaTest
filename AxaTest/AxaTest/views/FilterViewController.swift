//
//  FilterViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation
import UIKit

protocol FilterTableDelegate {
    
    func didSelectOption(_ option: String, inTable tableId: Int)
    func didUnselectOption(_ option: String, inTable tableId: Int)
    func didSelectOptionAll(inTable tableId: Int)
}

class FilterViewController: BaseViewController, FilterTableDelegate {
    
    @IBOutlet weak var resetBt: UIButton!
    @IBOutlet weak var applyBt: UIButton!
    
    private var filterActive = FilterUi()

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
        
        viewModel?.filterConfig.bind({ filterConfig in
            self.filterActive = filterConfig.filterActive
            // TODO: build UI with filter values and filter active
        })
    }
    
    @IBAction func didSelectReset() {
        viewModel?.didSelectReset()
    }
    
    @IBAction func didSelectApply() {
        viewModel?.didSelectApplyFilter(filterActive)
    }
    
    @IBAction func changedAgeSliderValue(_ sender: UISlider) {

    }
    
    @IBAction func changedWeightSliderValue(_ sender: UISlider) {

    }
    
    @IBAction func changedHeightSliderValue(_ sender: UISlider) {

    }
    
    @IBAction func didSelectHairColor() {
        // build table with `filterValues` and `filterActive`
        // `All` option will be added in table view class
    }
    
    @IBAction func didSelectProfession() {
        // move ""PROFESSION_NONE" to first position
        // build table with `filterValues` and `filterActive`
        // `All` option will be added in table view class
    }
    
    func didSelectOption(_ option: String, inTable tableId: Int) {
        // append option to `filterActive`
    }
    
    func didUnselectOption(_ option: String, inTable tableId: Int) {
        // remove option from `filterActive`
    }
    
    func didSelectOptionAll(inTable tableId: Int) {
        // append all options from `filterValues` to `filterActive`
    }
}
