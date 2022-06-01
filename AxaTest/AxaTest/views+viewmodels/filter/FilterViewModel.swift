//
//  FilterViewModel.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

enum FilterTransitions: String {
    
    case dismiss
    case toFilterHair
    case toFilterProfession
}

protocol FilterViewModelOutput: BaseViewModelOutput {
    
    var filterConfig: Box<FilterConfigUi> { get set }
    var transitionTo: Box<FilterTransitions?> { get set }
}

protocol FilterViewModelInput: BaseViewModelInput {
    
    func didSelectReset()
    func didSelectApplyFilter(_ filter: FilterUi)
    func didSelectHairColorOptions()
    func didSelectProfessionsOptions()
}

protocol FilterViewModel: BaseViewModel, FilterViewModelOutput, FilterViewModelInput {
 
    var getFilterValuesUseCase: GetFilterValuesUseCase { get set }
    var getFilterActiveUseCase: GetFilterActiveUseCase { get set }
    var saveFilterActiveUserCase: SaveFilterActiveUseCase { get set }
}

class DefaultFilterViewModel: BaseViewModel, FilterViewModel {

    var filterConfig = Box(FilterConfigUi(filterValues: FilterUi(), filterActive: FilterUi()))
    var transitionTo = Box<FilterTransitions?>(nil)
    var getFilterValuesUseCase: GetFilterValuesUseCase
    var getFilterActiveUseCase: GetFilterActiveUseCase
    var saveFilterActiveUserCase: SaveFilterActiveUseCase
    
    private var filterValues = Filter()

    internal init(getFilterValuesUseCase: GetFilterValuesUseCase,
                  getFilterActiveUseCase: GetFilterActiveUseCase,
                  saveFilterActiveUserCase: SaveFilterActiveUseCase) {
        
        self.getFilterValuesUseCase = getFilterValuesUseCase
        self.getFilterActiveUseCase = getFilterActiveUseCase
        self.saveFilterActiveUserCase = saveFilterActiveUserCase
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Task.init {
            do {
                isLoading.value = true
                let filterValues = try await getFilterValuesUseCase.execute()
                let filterActive = try await getFilterActiveUseCase.execute()
                isLoading.value = false
                self.filterConfig.value = FilterConfigUi(filterValues: filterValues.toFilterUi(),
                                                         filterActive: filterActive.toFilterUi())
                self.filterValues = filterValues
            } catch let error {
                isLoading.value = false
                self.showErrorAndDismiss(error: error)
            }
        }
    }
    
    func didSelectReset() {
        filterConfig.value = FilterConfigUi(filterValues: filterValues.toFilterUi(),
                                            filterActive: filterValues.toFilterUi())
    }
    
    func didSelectApplyFilter(_ filter: FilterUi) {

        Task.init {
            await saveFilterActiveUserCase.execute(filter: filter.toFilter())
            transitionTo.value = .dismiss
        }
    }
    
    func didSelectHairColorOptions() {
        transitionTo.value = .toFilterHair
    }
    
    func didSelectProfessionsOptions() {
        transitionTo.value = .toFilterProfession
    }
    
    private func showErrorAndDismiss(error: Error) {
        
        errorMessage.value = error.localizedDescription
        transitionTo.value = .dismiss
    }
}
