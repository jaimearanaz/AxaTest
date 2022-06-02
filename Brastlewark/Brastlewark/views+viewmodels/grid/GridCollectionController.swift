//
//  GridCollectionController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 2/6/22.
//

import Foundation
import UIKit

extension GridViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let character = viewModel?.characters.value[safe: indexPath.item] {
            viewModel?.didSelectCharacter(id: character.id)
        }
    }
}

extension GridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let num = viewModel?.characters.value.count
        return num ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let character = viewModel?.characters.value[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridViewCell.reuseIdentifier, for: indexPath) as? GridViewCell else {
            fatalError("cell or item is not available at indexPath \(indexPath) with \(viewModel?.characters.value.count ?? 0) items")
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
        
        if collectionCellSize.width.isZero {
            let paddingSpace = collectionSectionInsets.left * (collectionItemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / collectionItemsPerRow
            collectionCellSize = CGSize(width: widthPerItem, height:( widthPerItem * 3/2))
        }
        return collectionCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionSectionInsets.left
    }
}
