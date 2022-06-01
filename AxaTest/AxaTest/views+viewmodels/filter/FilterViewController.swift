//
//  FilterViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 27/5/22.
//

import Foundation
import UIKit
import MultiSlider

enum FilterOptionsType {
    case hair, professions
}

class FilterViewController: BaseViewController {

    @IBOutlet weak var ageLb: UILabel!
    @IBOutlet weak var weightLb: UILabel!
    @IBOutlet weak var heightLb: UILabel!
    @IBOutlet weak var friendsLb: UILabel!
    @IBOutlet weak var hairLb: UILabel!
    @IBOutlet weak var professionsLb: UILabel!
    @IBOutlet weak var ageSlider: MultiSlider!
    @IBOutlet weak var weightSlider: MultiSlider!
    @IBOutlet weak var heightSlider: MultiSlider!
    @IBOutlet weak var friendsSlider: MultiSlider!
    @IBOutlet weak var hairOptionsLb: UILabel!
    @IBOutlet weak var professionsOptionsLb: UILabel!

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
        professionsLb.text = "CHARACTER_PROFESSIONS".localized
    }
    
    override func customizeView() {
        
        super.customizeView()
        
        let applyButton = UIBarButtonItem(title: "FILTER_APPLY".localized, style: .plain, target: self, action: #selector(didSelectApply))
        let cleanButton = UIBarButtonItem(title: "FILTER_CLEAN".localized, style: .plain, target: self, action: #selector(didSelectClean))
        navigationItem.rightBarButtonItems = [applyButton, cleanButton]
        
        let titleLabels = [ageLb, weightLb, heightLb, friendsLb, hairLb, professionsLb]
        titleLabels.forEach { $0!.font = UIFont.black(withSize: 16) }
        let sliders = [ageSlider, weightSlider, heightSlider, friendsSlider]
        sliders.forEach { customizeSlider($0!) }
        let optionLabels = [hairOptionsLb, professionsOptionsLb]
        optionLabels.forEach { $0!.font = UIFont.regular(withSize: 18) }
        
        let hairLbTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectHairColor))
        hairLb.isUserInteractionEnabled = true
        hairLb.addGestureRecognizer(hairLbTapGesture)
        let hairOptionsTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectHairColor))
        hairOptionsLb.isUserInteractionEnabled = true
        hairOptionsLb.addGestureRecognizer(hairOptionsTapGesture)
        
        let professionsLbTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectProfession))
        professionsLb.isUserInteractionEnabled = true
        professionsLb.addGestureRecognizer(professionsLbTapGesture)
        let professionsOptionsTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectProfession))
        professionsOptionsLb.isUserInteractionEnabled = true
        professionsOptionsLb.addGestureRecognizer(professionsOptionsTapGesture)
    }
    
    @objc func didSelectClean() {
        viewModel?.didSelectReset()
    }
    
    @objc func didSelectApply() {
        
        let filterActive = FilterUi(age: Int(ageSlider.value.first!)...Int(ageSlider.value.last!),
                                    weight: Int(weightSlider.value.first!)...Int(weightSlider.value.last!),
                                    height: Int(heightSlider.value.first!)...Int(heightSlider.value.last!),
                                    hairColor: viewModel?.filterConfig.value.filterActive.hairColor ?? [String](),
                                    profession: viewModel?.filterConfig.value.filterActive.profession ?? [String](),
                                    friends: Int(friendsSlider.value.first!)...Int(friendsSlider.value.last!))
        viewModel?.didSelectApplyFilter(filterActive)
    }
    
    @IBAction func didSelectHairColor() {
        
        viewModel?.filterConfig.value.filterValues.hairColor.sort()
        viewModel?.didSelectHairColorOptions()
    }
    
    @IBAction func didSelectProfession() {
        
        viewModel?.filterConfig.value.filterValues.profession.sort()
        viewModel?.filterConfig.value.filterValues.profession.removeAll(where: { $0 == "PROFESSION_NONE".localized } )
        viewModel?.filterConfig.value.filterValues.profession.insert("PROFESSION_NONE".localized, at: 0)
        viewModel?.didSelectProfessionsOptions()
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
        
        updateSelectedHairColors()
        updateSelectedProfessions()
    }
    
    private func updateSelectedHairColors() {
        configureOptions(label: hairOptionsLb,
                         values: viewModel?.filterConfig.value.filterValues.hairColor,
                         active: viewModel?.filterConfig.value.filterActive.hairColor)
    }
    
    private func updateSelectedProfessions() {
        configureOptions(label: professionsOptionsLb,
                         values: viewModel?.filterConfig.value.filterValues.profession,
                         active: viewModel?.filterConfig.value.filterActive.profession)
    }
    
    private func configureOptions(label: UILabel, values: [String]?, active: [String]?) {
        
        guard let values = values,
              let active = active else {
            return
        }
        
        let allOptionsSelected = (values.count == active.count)
        if allOptionsSelected {
            label.text = "FILTER_OPTION_ALL".localized
        } else {
            label.text = active.joined(separator: ",  ")
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
    
    internal func getFilterOptionForProfessions() -> [FilterOptionUi] {
        
        guard let viewModel = viewModel else {
            fatalError("view model is no set in view controller")
        }
        return getFilterOptions(withValues: viewModel.filterConfig.value.filterValues.profession,
                                active: viewModel.filterConfig.value.filterActive.profession)
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

extension FilterViewController: FilterOptionsDelegate {
    
    
    func didSelectOption(title: String, identifier: FilterOptionsType?) {
        
        guard let identifier = identifier else {
            return
        }
        
        switch identifier {
            
        case .hair:
            viewModel?.filterConfig.value.filterActive.hairColor.append(title)
            updateSelectedHairColors()
        case .professions:
            viewModel?.filterConfig.value.filterActive.profession.append(title)
            updateSelectedProfessions()
        }
    }
    
    func didUnselectOption(title: String, identifier: FilterOptionsType?) {
        
        guard let identifier = identifier else {
            return
        }
        
        switch identifier {
            
        case .hair:
            viewModel?.filterConfig.value.filterActive.hairColor.removeAll(where: { $0 == title })
            updateSelectedHairColors()
        case .professions:
            viewModel?.filterConfig.value.filterActive.profession.removeAll(where: { $0 == title })
            updateSelectedProfessions()
        }
    }
    
    func didSelectOptionAll(identifier: FilterOptionsType?) {
        
        guard let identifier = identifier else {
            return
        }
        
        switch identifier {
        case .hair:
            if let values = viewModel?.filterConfig.value.filterValues.hairColor {
                viewModel?.filterConfig.value.filterActive.hairColor = values
            }
            updateSelectedHairColors()
        case .professions:
            if let values = viewModel?.filterConfig.value.filterValues.profession {
                viewModel?.filterConfig.value.filterActive.profession = values
            }
            updateSelectedProfessions()
        }
    }
    
    func didUnselectOptionAll(identifier: FilterOptionsType?) {
        
        guard let identifier = identifier else {
            return
        }
        
        switch identifier {
        case .hair:
            viewModel?.filterConfig.value.filterActive.hairColor = [String]()
        case .professions:
            viewModel?.filterConfig.value.filterActive.profession = [String]()
        }
    }
}
