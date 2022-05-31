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
    
    private var filterActive = FilterUi()

    var viewModel: FilterViewModel? { didSet { baseViewModel = viewModel } }

    override func binds() {

        super.binds()
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
            self.configureFilter(withFilter: self.filterActive)
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
        ageLb.font = UIFont.black(withSize: 16)
        weightLb.font = UIFont.black(withSize: 16)
        heightLb.font = UIFont.black(withSize: 16)
        friendsLb.font = UIFont.black(withSize: 16)
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
    
    private func configureFilter(withFilter filter: FilterUi) {
        
        configureSlider(ageSlider, withRange: filter.age)
        configureSlider(weightSlider, withRange: filter.weight)
        configureSlider(heightSlider, withRange: filter.height)
        configureSlider(friendsSlider, withRange: filter.friends)

        ageSlider.value = [CGFloat(filter.age.lowerBound), CGFloat(filter.age.upperBound)]
        weightSlider.value = [CGFloat(filter.weight.lowerBound), CGFloat(filter.age.upperBound)]
        heightSlider.value = [CGFloat(filter.height.lowerBound), CGFloat(filter.height.upperBound)]
        friendsSlider.value = [CGFloat(filter.friends.lowerBound), CGFloat(filter.friends.upperBound)]
    }
    
    private func configureSlider(_ slider: MultiSlider, withRange range: ClosedRange<Int>) {
        
        slider.isVertical = false
        slider.isContinuous = true
        slider.snapStepSize = 1
        slider.thumbCount = 1
        slider.valueLabelPosition = .top
        slider.outerTrackColor = .lightGray
        slider.distanceBetweenThumbs = 0
        slider.minimumValue = CGFloat(range.lowerBound)
        slider.maximumValue = CGFloat(range.upperBound)
    }
}
