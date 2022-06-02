//
//  ViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import UIKit
import SDWebImage

class GridViewController: BaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var emptyLb: UILabel!
    
    var viewModel: GridViewModel? { didSet { baseViewModel = viewModel } }
    var navigationFlow: GridNavigationFlow?
    
    let collectionItemsPerRow: CGFloat = 3
    let collectionSectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    var collectionCellSize = CGSize(width: 0, height: 0)
    
    private var refreshControl = UIRefreshControl()
    private var resetButton: UIBarButtonItem?
        
    override func binds() {

        super.binds()
        viewModel?.isLoading.bind({ isLoading in
            DispatchQueue.main.async {
                switch isLoading {
                case true:
                    self.startLoading()
                case false:
                    self.stopLoading()
                    break
                }
            }
        })
        
        viewModel?.errorMessage.bind({ errorMessage in
            DispatchQueue.main.async {
                self.showAlert(withMessage: errorMessage)
            }
        })
        
        viewModel?.characters.bind({ characters in
            DispatchQueue.main.async {
                self.emptyLb.isHidden = characters.isNotEmpty
                self.refreshControl.endRefreshing()
                self.collectionView.setContentOffset(.zero, animated: true)
                self.collectionView.reloadData()
            }
        })
        
        viewModel?.isFilterActive.bind({ isActive in
            DispatchQueue.main.async {
                self.resetButton?.isEnabled = isActive
            }
        })
        
        viewModel?.isSearching.bind({ isSearching in
            DispatchQueue.main.async {
                if !isSearching {
                    self.resetSearchBar()
                }
            }
        })
        
        viewModel?.transitionTo.bind({ transitionTo in
            DispatchQueue.main.async {
                if let transitionTo = transitionTo {
                    self.route(transitionTo: transitionTo)
                }
            }
        })
    }
    
    override func customizeView() {
        
        super.customizeView()
        
        let filterButton = UIBarButtonItem(title: "FILTER_ACTION".localized, style: .plain, target: self, action: #selector(didSelectFilter))
        resetButton = UIBarButtonItem(title: "FILTER_RESET".localized, style: .plain, target: self, action: #selector(didSelectReset))
        resetButton!.isEnabled = false
        navigationItem.rightBarButtonItems = [filterButton, resetButton!]
        
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = true
        label.text = "Brastlewark"
        label.font = UIFont.special_22()
        navigationItem.titleView = label
        
        activityIndicatorView.isHidden = true
        emptyLb.isHidden = true
        emptyLb.font = UIFont.regular_18()
        emptyLb.textColor = UIColor.gray
        
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(didRefresh), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "GRID_PULL_TO_REFRESH".localized)
        collectionView.addSubview(refreshControl)
        
        searchBar.placeholder = "GRID_SEARCHBAR_PLACEHOLDER".localized
    }
    
    override func localizeView() {
        
        super.localizeView()
        emptyLb.text = "GRID_EMPTY".localized
    }
    
    @objc func didSelectFilter() {
        viewModel?.didSelectFilter()
    }
    
    @objc func didSelectReset() {
        
        collectionView.setContentOffset(.zero, animated: true)
        viewModel?.didSelectReset()
    }
    
    @objc func didSelectCharacter() {
        
        searchBar.resignFirstResponder()
        viewModel?.didSelectCharacter(id: 1)
    }
    
    @objc func didRefresh() {
        viewModel?.didRefresh()
    }
    
    func startLoading() {
        
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
    }
    
    func stopLoading() {
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    
    private func resetSearchBar() {
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension GridViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.didEditSearch(search: searchText)
    }
}
