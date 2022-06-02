//
//  OptionsTableViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 1/6/22.
//

import Foundation
import UIKit

protocol FilterOptionsDelegate: AnyObject {
    
    func didSelectOption(title: String, identifier: FilterOptionsType?)
    func didUnselectOption(title: String, identifier: FilterOptionsType?)
    func didSelectOptionAll(identifier: FilterOptionsType?)
    func didUnselectOptionAll(identifier: FilterOptionsType?)
}

class FilterOptionsTableViewController: UITableViewController {

    private let reuseIdentifier = "FilterOptionViewCell"
    private let optionAllTitle = "FILTER_OPTION_ALL".localized
    
    weak var delegate: FilterOptionsDelegate?
    var identifier: FilterOptionsType?
    private var items = [FilterOptionUi]()
    
    func setItems(_ items: [FilterOptionUi]) {
        
        addOptionAllToItems(items)
        let isAllSelected = (items.filter { $0.isSelected == true }.count == items.count)
        if isAllSelected {
            selectOptionAll()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = items[safe: indexPath.row] else {
            fatalError("cell or item is not available")
        }
        
        let isTheOnlyOptionSelected = (items.filter { $0.isSelected == true }.count == 1) && item.isSelected
        let isOptionAll = (item.title == optionAllTitle)
        
        if isTheOnlyOptionSelected {
            return
        } else if isOptionAll {
            handleSelectionOfItemAll()
            tableView.reloadData()
        } else {
            handlSelectionOfItem(item)
            tableView.reloadData()
        }
    }
            
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = items[safe: indexPath.row] else {
            fatalError("cell or item is not available")
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = item.title
        cell.contentConfiguration = configuration
        cell.accessoryType = item.isSelected ? .checkmark : .none

        return cell
    }
    
    
    private func addOptionAllToItems(_ items: [FilterOptionUi]) {
        
        var itemsWithAll = items
        let allOption = FilterOptionUi(title: optionAllTitle, isSelected: false)
        itemsWithAll.insert(allOption, at: 0)
        self.items = itemsWithAll
    }
    
    private func handleSelectionOfItemAll() {
        
        selectOptionAll()
        delegate?.didSelectOptionAll(identifier: identifier)
    }
    
    private func handlSelectionOfItem(_ item: FilterOptionUi) {
        
        if (item.isSelected) {
            unselectOption(title: item.title)
            delegate?.didUnselectOption(title: item.title, identifier: identifier)
        } else {
            if unselectOptionAllIfNeeded() {
                delegate?.didUnselectOptionAll(identifier: identifier)
            }
            selectOption(title: item.title)
            delegate?.didSelectOption(title: item.title, identifier: identifier)
        }
    }
    
    private func selectOptionAll() {

        items = items.map { item -> FilterOptionUi in
            var newItem = item
            let isAllOption = (item.title == optionAllTitle)
            newItem.isSelected = isAllOption ? true : false
            return newItem
        }
    }
    
    private func unselectOptionAllIfNeeded() -> Bool {
        
        var wasNeeded = false
        items = items.map { item -> FilterOptionUi in
            var newItem = item
            let isAllSelected = (item.title == optionAllTitle) && (item.isSelected)
            if isAllSelected {
                newItem.isSelected = false
                wasNeeded = true
            } else {
                newItem.isSelected = item.isSelected
            }
            return newItem
        }
        
        return wasNeeded
    }
    
    private func selectOption(title: String) {
        
        items = items.map { item -> FilterOptionUi in
            var newItem = item
            let isSelectedOption = (item.title == title)
            newItem.isSelected = isSelectedOption ? true : item.isSelected
            return newItem
        }
    }
    
    private func unselectOption(title: String) {
        
        items = items.map { item -> FilterOptionUi in
            var newItem = item
            let isUnselectedOption = (item.title == title)
            newItem.isSelected = isUnselectedOption ? false : item.isSelected
            return newItem
        }
    }
}
