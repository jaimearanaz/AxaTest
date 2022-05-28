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
    
    var filterValues: Box<Filter> { get set }
    var activeFilter: Box<Filter> { get set }
    var transitionTo: Box<FilterTransitions> { get set }
    var errorMessage: Box<String> { get set }
}

protocol FilterViewModelInput: BaseViewModelInput {
    
    func didSelectReset()
    func didSelectApplyFilter(_ filter: Filter)
}

protocol FilterViewModel: BaseViewModel, FilterViewModelOutput, FilterViewModelInput {
 
    var getFilterValuesUseCase: GetFilterValuesUseCase { get set }
    var getActiveFilterUseCase: GetActiveFilterUseCase { get set }
    var saveActiveFilterUserCase: SaveActiveFilterUseCase { get set }
}

class DefaultFilterViewModel: BaseViewModel, FilterViewModel {

    var filterValues = Box(Filter())
    var activeFilter = Box(Filter())
    var transitionTo = Box(FilterTransitions.none)
    var errorMessage = Box("")
    var getFilterValuesUseCase: GetFilterValuesUseCase
    var getActiveFilterUseCase: GetActiveFilterUseCase
    var saveActiveFilterUserCase: SaveActiveFilterUseCase

    internal init(getFilterValuesUseCase: GetFilterValuesUseCase,
                  getActiveFilterUseCase: GetActiveFilterUseCase,
                  saveActiveFilterUserCase: SaveActiveFilterUseCase) {
        
        self.getFilterValuesUseCase = getFilterValuesUseCase
        self.getActiveFilterUseCase = getActiveFilterUseCase
        self.saveActiveFilterUserCase = saveActiveFilterUserCase
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        getFilterValuesUseCase.execute { result in
            
            switch result {
                
            case .success(let filterValues):
                
                self.filterValues.value = filterValues
                self.getActiveFilterUseCase.execute { result in
                    
                    switch result {
                        
                    case .success(let activeFilter):
                        self.activeFilter.value = activeFilter
                    case .failure(let error):
                        self.errorMessage.value = error.localizedDescription
                    }
                }

            case .failure(let error):
                self.errorMessage.value = error.localizedDescription
            }
        }
        
        
    }
    
    func didSelectReset() {
        print("didSelectReset")
    }
    
    func didSelectApplyFilter(_ filter: Filter) {
        print("didSelecApplyFilter")
    }
}
