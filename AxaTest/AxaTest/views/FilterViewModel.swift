//
//  FilterViewModel.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation

enum FilterTransitions: String {
    
    case none
    case dismiss
}

protocol FilterViewModelOutput: BaseViewModelOutput {
    
    var filterConfig: Box<FilterConfigUi> { get set }
    var transitionTo: Box<FilterTransitions> { get set }
}

protocol FilterViewModelInput: BaseViewModelInput {
    
    func didSelectReset()
    func didSelectApplyFilter(_ filter: FilterUi)
}

protocol FilterViewModel: BaseViewModel, FilterViewModelOutput, FilterViewModelInput {
 
    var getFilterValuesUseCase: GetFilterValuesUseCase { get set }
    var getFilterActiveUseCase: GetFilterActiveUseCase { get set }
    var saveFilterActiveUserCase: SaveFilterActiveUseCase { get set }
}

class DefaultFilterViewModel: BaseViewModel, FilterViewModel {

    var filterConfig = Box(FilterConfigUi(filterValues: FilterUi(), filterActive: FilterUi()))
    var transitionTo = Box(FilterTransitions.none)
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
        
        getFilterValuesUseCase.execute { result in
            
            switch result {
            case .success(let filterValues):
                
                self.filterValues = filterValues
                self.getFilterActiveUseCase.execute { result in
                    
                    switch result {
                    case .success(let filterActive):
                        self.filterConfig.value = FilterConfigUi(filterValues: filterValues.toFilterUi(),
                                                                 filterActive: filterActive.toFilterUi())
                    case .failure(let error):
                        self.showErrorAndDismiss(error: error)
                    }
                }

            case .failure(let error):
                self.showErrorAndDismiss(error: error)
            }
        }
    }
    
    func didSelectReset() {
        filterConfig.value = FilterConfigUi(filterValues: filterValues.toFilterUi(),
                                            filterActive: filterValues.toFilterUi())
    }
    
    func didSelectApplyFilter(_ filter: FilterUi) {

        saveFilterActiveUserCase.execute(filter: filter.toFilter()) { result in
            
            switch result {
            case .success():
                self.transitionTo.value = .dismiss
            case .failure(let error):
                self.showErrorAndDismiss(error: error)
            }
        }
    }
    
    private func showErrorAndDismiss(error: Error) {
        
        errorMessage.value = error.localizedDescription
        transitionTo.value = .dismiss
    }
}
