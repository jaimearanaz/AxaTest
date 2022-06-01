//
//  FilterViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation
import UIKit
import MultiSlider

protocol FilterTableDelegate {
    
    func didSelectOption(_ option: String, inTable tableId: Int)
    func didUnselectOption(_ option: String, inTable tableId: Int)
    func didSelectOptionAll(inTable tableId: Int)
}

class FilterViewController: BaseViewController, FilterTableDelegate {
    
    @IBOutlet weak var ageLb: UILabel!
    @IBOutlet weak var weightLb: UILabel!
    @IBOutlet weak var heightLb: UILabel!
    @IBOutlet weak var friendsLb: UILabel!
    @IBOutlet weak var ageSlider: MultiSlider!
    @IBOutlet weak var weightSlider: MultiSlider!
    @IBOutlet weak var heightSlider: MultiSlider!
    @IBOutlet weak var friendsSlider: MultiSlider!

    var viewModel: FilterViewModel? { didSet { baseViewModel = viewModel } }

    override func binds() {

        super.binds()
        viewModel?.transitionTo.bind({ transitionTo in
            if let transitionTo = transitionTo {
                self.route(transitionTo: transitionTo)
            }
        })
        
        viewModel?.filterConfig.bind({ filterConfig in
            self.configureFilter(values: filterConfig.filterValues,
                                 active: filterConfig.filterActive)
        })
        
        viewModel?.errorMessage.bind({ errorMessage in
            DispatchQueue.main.async {
                self.showAlert(withMessage: errorMessage)
            }
        })
    }
    
    override func localizeView() {
        
        super.localizeView()
        ageLb.text = "CHARACTER_AGE".localized
        weightLb.text = "CHARACTER_WEIGHT".localized
        heightLb.text = "CHARACTER_HEIGHT".localized
        friendsLb.text = "CHARACTER_FRIENDS".localized
    }
    
    override func customizeView() {
        
        super.customizeView()
        
        let applyButton = UIBarButtonItem(title: "FILTER_APPLY".localized, style: .plain, target: self, action: #selector(didSelectApply))
        let cleanButton = UIBarButtonItem(title: "FILTER_CLEAN".localized, style: .plain, target: self, action: #selector(didSelectClean))
        navigationItem.rightBarButtonItems = [applyButton, cleanButton]
        
        let labels = [ageLb, weightLb, heightLb, friendsLb]
        labels.forEach { $0!.font = UIFont.black(withSize: 16) }
        let sliders = [ageSlider, weightSlider, heightSlider, friendsSlider]
        sliders.forEach { customizeSlider($0!) }
    }
    
    @objc func didSelectClean() {
        viewModel?.didSelectReset()
    }
    
    @objc func didSelectApply() {
        
        let filterActive = FilterUi(age: Int(ageSlider.value.first!)...Int(ageSlider.value.last!),
                                    weight: Int(weightSlider.value.first!)...Int(weightSlider.value.last!),
                                    height: Int(heightSlider.value.first!)...Int(heightSlider.value.last!),
                                    hairColor: viewModel?.filterConfig.value.filterValues.hairColor ?? [String](),
                                    profession: viewModel?.filterConfig.value.filterValues.profession ?? [String](),
                                    friends: Int(friendsSlider.value.first!)...Int(friendsSlider.value.last!))
        viewModel?.didSelectApplyFilter(filterActive)
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
    
    private func customizeSlider(_ slider: MultiSlider) {
        
        slider.isVertical = false
        slider.isContinuous = true
        slider.snapStepSize = 1
        slider.thumbCount = 1
        slider.valueLabelPosition = .top
        slider.outerTrackColor = .lightGray
        slider.distanceBetweenThumbs = 0
    }
    
    private func configureFilter(values filterValues: FilterUi, active filterActive: FilterUi) {
        
        configureSlider(ageSlider, values: filterValues.age, active: filterActive.age)
        configureSlider(weightSlider, values: filterValues.weight, active: filterActive.weight)
        configureSlider(heightSlider, values: filterValues.height, active: filterActive.height)
        configureSlider(friendsSlider, values: filterValues.friends, active: filterActive.friends)
    }
    
    private func configureSlider(_ slider: MultiSlider, values: ClosedRange<Int>, active: ClosedRange<Int>) {
        
        slider.minimumValue = CGFloat(values.lowerBound)
        slider.maximumValue = CGFloat(values.upperBound)
        slider.value = [CGFloat(active.lowerBound), CGFloat(active.upperBound)]
    }
}
