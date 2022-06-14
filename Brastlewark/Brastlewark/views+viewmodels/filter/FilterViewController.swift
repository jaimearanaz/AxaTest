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
    private var filterActive = FilterUi()
    private var filterValues = FilterUi()

    override func binds() {

        super.binds()
        viewModel?.transitionTo.bind({ transitionTo in
            DispatchQueue.main.async {
                if let transitionTo = transitionTo {
                    self.perfomTransition(to: transitionTo)
                }
            }
        })
        
        viewModel?.filterConfig.bind({ filterConfig in
            DispatchQueue.main.async {
                self.filterActive = filterConfig.filterActive
                self.filterValues = filterConfig.filterValues
                self.configureFilter(values: self.filterValues,
                                     active: self.filterActive)
            }
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
        titleLabels.forEach { $0!.font = UIFont.black_16() }
        let sliders = [ageSlider, weightSlider, heightSlider, friendsSlider]
        sliders.forEach { customizeSlider($0!) }
        let optionLabels = [hairOptionsLb, professionsOptionsLb]
            optionLabels.forEach { $0!.font = UIFont.regular_18() }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        switch (segue.identifier) {
            
        case FilterTransitions.toFilterHair.rawValue:
            let viewController = segue.destination as! FilterOptionsTableViewController
            let hairOptions = getFilterOptionForHairColors()
            viewController.setItems(hairOptions)
            viewController.delegate = self
            viewController.identifier = FilterOptionsType.hair
            
        case FilterTransitions.toFilterProfession.rawValue:
            let viewController = segue.destination as! FilterOptionsTableViewController
            let professionsOptions = getFilterOptionForProfessions()
            viewController.setItems(professionsOptions)
            viewController.delegate = self
            viewController.identifier = FilterOptionsType.professions
            
        default:
            break
        }
    }
    
    @objc func didSelectClean() {
        viewModel?.didSelectReset()
    }
    
    @objc func didSelectApply() {
        
        let filterActive = FilterUi(age: Int(ageSlider.value.first!)...Int(ageSlider.value.last!),
                                    weight: Int(weightSlider.value.first!)...Int(weightSlider.value.last!),
                                    height: Int(heightSlider.value.first!)...Int(heightSlider.value.last!),
                                    hairColor: filterActive.hairColor,
                                    profession: filterActive.profession,
                                    friends: Int(friendsSlider.value.first!)...Int(friendsSlider.value.last!))
        viewModel?.didSelectApplyFilter(filterActive)
    }
    
    @IBAction func didSelectHairColor() {
        
        filterValues.hairColor.sort()
        viewModel?.didSelectHairColorOptions()
    }
    
    @IBAction func didSelectProfession() {
        
        filterValues.profession.sort()
        filterValues.profession.removeAll(where: { $0 == "PROFESSION_NONE".localized } )
        filterValues.profession.insert("PROFESSION_NONE".localized, at: 0)
        viewModel?.didSelectProfessionsOptions()
    }
    
    private func perfomTransition(to transitionTo: FilterTransitions) {
        
        switch transitionTo {
        case .dismiss:
            navigationController?.popToRootViewController(animated: true)
        case .toFilterHair:
            performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        case .toFilterProfession:
            performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        }
    }
    
    private func customizeSlider(_ slider: MultiSlider) {
        
        slider.isVertical = false
        slider.isContinuous = true
        slider.snapStepSize = 1
        slider.thumbCount = 1
        slider.valueLabelPosition = .top
        slider.outerTrackColor = .lightGray
        slider.distanceBetweenThumbs = 0
        slider.isHapticSnap = false
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
                         values: filterValues.hairColor,
                         active: filterActive.hairColor)
    }
    
    private func updateSelectedProfessions() {
        configureOptions(label: professionsOptionsLb,
                         values: filterValues.profession,
                         active: filterActive.profession)
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
        
        return getFilterOptions(withValues: filterValues.hairColor,
                                active: filterActive.hairColor)
    }
    
    internal func getFilterOptionForProfessions() -> [FilterOptionUi] {
        
        guard let _ = viewModel else {
            fatalError("view model is no set in view controller")
        }
        return getFilterOptions(withValues: filterValues.profession,
                                active: filterActive.profession)
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
            filterActive.hairColor.append(title)
            updateSelectedHairColors()
        case .professions:
            filterActive.profession.append(title)
            updateSelectedProfessions()
        }
    }
    
    func didUnselectOption(title: String, identifier: FilterOptionsType?) {
        
        guard let identifier = identifier else {
            return
        }
        
        switch identifier {
            
        case .hair:
            filterActive.hairColor.removeAll(where: { $0 == title })
            updateSelectedHairColors()
        case .professions:
            filterActive.profession.removeAll(where: { $0 == title })
            updateSelectedProfessions()
        }
    }
    
    func didSelectOptionAll(identifier: FilterOptionsType?) {
        
        guard let identifier = identifier else {
            return
        }
        
        switch identifier {
        case .hair:
            filterActive.hairColor = filterValues.hairColor
            updateSelectedHairColors()
        case .professions:
            filterActive.profession = filterValues.profession
            updateSelectedProfessions()
        }
    }
    
    func didUnselectOptionAll(identifier: FilterOptionsType?) {
        
        guard let identifier = identifier else {
            return
        }
        
        switch identifier {
        case .hair:
            filterActive.hairColor = [String]()
        case .professions:
            filterActive.profession = [String]()
        }
    }
}
