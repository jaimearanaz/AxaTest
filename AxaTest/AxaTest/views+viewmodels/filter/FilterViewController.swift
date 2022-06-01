//
//  FilterViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation
import UIKit
import MultiSlider

class FilterViewController: BaseViewController, FilterOptionsDelegate {

    @IBOutlet weak var ageLb: UILabel!
    @IBOutlet weak var weightLb: UILabel!
    @IBOutlet weak var heightLb: UILabel!
    @IBOutlet weak var friendsLb: UILabel!
    @IBOutlet weak var hairLb: UILabel!
    @IBOutlet weak var ageSlider: MultiSlider!
    @IBOutlet weak var weightSlider: MultiSlider!
    @IBOutlet weak var heightSlider: MultiSlider!
    @IBOutlet weak var friendsSlider: MultiSlider!
    @IBOutlet weak var hairOptionsLb: UILabel!

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
        hairLb.text = "CHARACTER_HAIR".localized
    }
    
    override func customizeView() {
        
        super.customizeView()
        
        let applyButton = UIBarButtonItem(title: "FILTER_APPLY".localized, style: .plain, target: self, action: #selector(didSelectApply))
        let cleanButton = UIBarButtonItem(title: "FILTER_CLEAN".localized, style: .plain, target: self, action: #selector(didSelectClean))
        navigationItem.rightBarButtonItems = [applyButton, cleanButton]
        
        let titleLabels = [ageLb, weightLb, heightLb, friendsLb, hairLb]
        titleLabels.forEach { $0!.font = UIFont.black(withSize: 16) }
        let sliders = [ageSlider, weightSlider, heightSlider, friendsSlider]
        sliders.forEach { customizeSlider($0!) }
        let optionLabels = [hairOptionsLb]
        optionLabels.forEach { $0!.font = UIFont.regular(withSize: 18) }
        
        let hairLbTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectHairColor))
        hairLb.isUserInteractionEnabled = true
        hairLb.addGestureRecognizer(hairLbTapGesture)
        let hairOptionsTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectHairColor))
        hairOptionsLb.isUserInteractionEnabled = true
        hairOptionsLb.addGestureRecognizer(hairOptionsTapGesture)
    }
    
    @objc func didSelectClean() {
        viewModel?.didSelectReset()
    }
    
    @objc func didSelectApply() {
        
        let filterActive = FilterUi(age: Int(ageSlider.value.first!)...Int(ageSlider.value.last!),
                                    weight: Int(weightSlider.value.first!)...Int(weightSlider.value.last!),
                                    height: Int(heightSlider.value.first!)...Int(heightSlider.value.last!),
                                    hairColor: viewModel?.filterConfig.value.filterActive.hairColor ?? [String](),
                                    profession: viewModel?.filterConfig.value.filterValues.profession ?? [String](),
                                    friends: Int(friendsSlider.value.first!)...Int(friendsSlider.value.last!))
        viewModel?.didSelectApplyFilter(filterActive)
    }
    
    @IBAction func didSelectHairColor() {
        viewModel?.didSelectHairColorOptions()
    }
    
    @IBAction func didSelectProfession() {
        // move ""PROFESSION_NONE" to first position
        viewModel?.didSelectProfessionsOptions()
    }
    
    func didSelectOption(title: String, sender: FilterOptionsViewController) {

        if var filterActive = viewModel?.filterConfig.value.filterActive,
           let filterValues = viewModel?.filterConfig.value.filterValues,
           var activeHairColor = viewModel?.filterConfig.value.filterActive.hairColor {
               
            activeHairColor.append(title)
            filterActive.hairColor = activeHairColor
            viewModel?.filterConfig.value.filterActive = filterActive
            configureHairColors(values: filterValues.hairColor, active: filterActive.hairColor)
        }
    }
    
    func didUnselectOption(title: String, sender: FilterOptionsViewController) {

        if var filterActive = viewModel?.filterConfig.value.filterActive,
           let filterValues = viewModel?.filterConfig.value.filterValues,
           var activeHairColor = viewModel?.filterConfig.value.filterActive.hairColor {
               
            activeHairColor.removeAll(where: { $0 == title })
            filterActive.hairColor = activeHairColor
            viewModel?.filterConfig.value.filterActive = filterActive
            configureHairColors(values: filterValues.hairColor, active: filterActive.hairColor)
        }
    }
    
    func didSelectOptionAll(sender: FilterOptionsViewController) {
        
        if var filterActive = viewModel?.filterConfig.value.filterActive,
           let filterValues = viewModel?.filterConfig.value.filterValues,
           let allHairColors = viewModel?.filterConfig.value.filterValues.hairColor {
               
            filterActive.hairColor = allHairColors
            viewModel?.filterConfig.value.filterActive = filterActive
            configureHairColors(values: filterValues.hairColor, active: filterActive.hairColor)
        }
    }
    
    func didUnselectOptionAll(sender: FilterOptionsViewController) {
        viewModel?.filterConfig.value.filterActive.hairColor = [String]()
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
        
        configureHairColors(values: filterValues.hairColor, active: filterActive.hairColor)
    }
    
    private func configureHairColors(values: [String], active: [String]) {
        
        let allOptionsSelected = (values.count == active.count)
        if allOptionsSelected {
            hairOptionsLb.text = "FILTER_OPTION_ALL".localized
        } else {
            hairOptionsLb.text = active.joined(separator: ",  ")
        }
    }
    
    private func configureSlider(_ slider: MultiSlider, values: ClosedRange<Int>, active: ClosedRange<Int>) {
        
        slider.minimumValue = CGFloat(values.lowerBound)
        slider.maximumValue = CGFloat(values.upperBound)
        slider.value = [CGFloat(active.lowerBound), CGFloat(active.upperBound)]
    }
    
    private func hairFilterOptions() -> [FilterOptionUi] {
        
        guard let viewModel = viewModel else {
            fatalError("view model is no set in view controller")
        }
        
        var filterOptions = [FilterOptionUi]()
        viewModel.filterConfig.value.filterValues.hairColor.forEach({ color in
            let isSelected = viewModel.filterConfig.value.filterActive.hairColor.contains(color)
            let option = FilterOptionUi(title: color, isSelected: isSelected)
            filterOptions.append(option)
        })
        
        return filterOptions
    }
    
    internal func getFilterOptionForHairColors() -> [FilterOptionUi] {
        
        guard let viewModel = viewModel else {
            fatalError("view model is no set in view controller")
        }
        return getFilterOptions(withValues: viewModel.filterConfig.value.filterValues.hairColor,
                                active: viewModel.filterConfig.value.filterActive.hairColor)
    }

    internal func getFilterOptions(withValues values: [String], active: [String]) -> [FilterOptionUi] {
        
        var filterOptions = [FilterOptionUi]()
        values.forEach({ oneValue in
            let isSelected = active.contains(oneValue)
            let option = FilterOptionUi(title: oneValue, isSelected: isSelected)
            filterOptions.append(option)
        })
        return filterOptions
    }
}
