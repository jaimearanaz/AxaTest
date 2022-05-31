//
//  ViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import UIKit
import SDWebImage

class GridViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var emptyLb: UILabel!
    
    var viewModel: GridViewModel? { didSet { baseViewModel = viewModel } }
    var navigationFlow: GridNavigationFlow?
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(
      top: 16.0,
      left: 16.0,
      bottom: 16.0,
      right: 16.0)
    private var cellSize = CGSize(width: 0, height: 0)
    
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
                self.collectionView.reloadData()
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
            }
        })
        
        viewModel?.transitionTo.bind({ transitionTo in
            if let transitionTo = transitionTo {
                self.route(transitionTo: transitionTo)
            }
        })
    }
    
    override func customizeView() {
        
        super.customizeView()
        
        let filterButton = UIBarButtonItem(title: "FILTER_ACTION".localized, style: .plain, target: self, action: #selector(didSelectFilter))
        let resetButton = UIBarButtonItem(title: "FILTER_RESET".localized, style: .plain, target: self, action: #selector(didSelectReset))
        navigationItem.rightBarButtonItems = [filterButton, resetButton]
        
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = true
        label.text = "Brastlewark"
        label.font = UIFont.castle(withSize: 22)
        navigationItem.titleView = label
        
        activityIndicatorView.isHidden = true
        emptyLb.isHidden = true
        emptyLb.font = UIFont.regular(withSize: 18)
        emptyLb.textColor = UIColor.gray
    }
    
    override func localizeView() {
        
        super.localizeView()
        emptyLb.text = "GRID_EMPTY".localized
    }
    
    @objc func didSelectFilter() {
        viewModel?.didSelectFilter()
    }
    
    @objc func didSelectReset() {
        viewModel?.didSelectReset()
    }
    
    @objc func didSelectCharacter() {
        viewModel?.didSelectCharacter(id: 1)
    }
    
    func startLoading() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
    }
    
    func stopLoading() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
}

extension GridViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let character = viewModel?.characters.value[safe: indexPath.item] {
            viewModel?.didSelectCharacter(id: character.id)
        }
    }
}

extension GridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.characters.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let character = viewModel?.characters.value[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridViewCell.reuseIdentifier, for: indexPath) as? GridViewCell else {
            fatalError("cell or item is not available")
        }

        cell.firstName.text = character.name.firstname()
        cell.surname.text = character.name.surname()
        if let url = URL(string: character.thumbnail) {
            cell.imageView.sd_setImage(with: url)
        }
        return cell
    }
}

extension GridViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if cellSize.width.isZero {
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            cellSize = CGSize(width: widthPerItem, height:( widthPerItem * 3/2))
        }
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
