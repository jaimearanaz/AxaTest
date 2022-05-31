//
//  CharacterViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 28/5/22.
//

import Foundation
import UIKit
import SDWebImage

class CharacterDetailsViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var ageLb: UILabel!
    @IBOutlet weak var weightLb: UILabel!
    @IBOutlet weak var heightLb: UILabel!
    @IBOutlet weak var hairColorLb: UILabel!
    @IBOutlet weak var professionsLb: UILabel!
    @IBOutlet weak var friendsLb: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: CharacterDetailsViewModel? { didSet { baseViewModel = viewModel } }
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(
      top: 16.0,
      left: 16.0,
      bottom: 16.0,
      right: 16.0)
    private var cellSize = CGSize(width: 0, height: 0)
    
    override func binds() {
        
        super.binds()
        viewModel?.character.bind({ character in
            self.configCharacter(character)
        })
        
        viewModel?.errorMessage.bind({ errorMessage in
            DispatchQueue.main.async {
                self.showAlert(withMessage: errorMessage)
            }
        })
    }
    
    override func customizeView() {
        
        super.customizeView()
        collectionView.register(GridViewCell.self, forCellWithReuseIdentifier: GridViewCell.reuseIdentifier)
    }
    
    @IBAction func didSelectFriend() {
        viewModel?.didSelectFriend(id: Int.random(in: 1..<2000))
    }
    
    private func configCharacter(_ character: CharacterDetailsUi) {
        
        if let url = URL(string: character.thumbnail) {
            self.imageView.sd_setImage(with: url)
        }
        
        nameLb.font = UIFont.castle(withSize: 20)
        nameLb.text = character.name
        
        ageLb.attributedText = attributedSection(title: "CHARACTER_AGE".localized,
                                                 value: String(character.age))
        weightLb.attributedText = attributedSection(title: "CHARACTER_WEIGHT".localized,
                                                    value: String(character.weight))
        heightLb.attributedText = attributedSection(title: "CHARACTER_HEIGHT".localized,
                                                    value: String(character.height))
        hairColorLb.attributedText = attributedSection(title: "CHARACTER_HAIR_COLOR".localized,
                                                       value: String(character.hairColor))
        professionsLb.attributedText = attributedSection(title: "CHARACTER_PROFESSIONS".localized,
                                                         value: String(character.professions.joined(separator: ", ")))
        
        friendsLb.font = UIFont.black(withSize: 18)
        friendsLb.text = "CHARACTER_FRIENDS".localized
    }
    
    private func attributedSection(title: String, value: String) -> NSAttributedString {
        
        let string = "\(title): \(value)"
        let attributedString = NSMutableAttributedString(string: string)
        
        let titleRange = NSRange(location: 0, length: title.count + 1)
        let titleAttributes = [NSAttributedString.Key.font: UIFont.black(withSize: 18)]
        attributedString.addAttributes(titleAttributes, range: titleRange)

        let valueRange = NSRange(location: titleRange.length, length: value.count)
        let valueAttributes = [NSMutableAttributedString.Key.font: UIFont.regular(withSize: 16)]
        attributedString.addAttributes(valueAttributes, range: valueRange)

        return attributedString.withLineSpacing(8)
    }
}

extension CharacterDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let friend = viewModel?.character.value.friends[safe: indexPath.item] {
            viewModel?.didSelectFriend(id: friend.id)
        }
    }
}

extension CharacterDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.character.value.friends.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let friend = viewModel?.character.value.friends[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridViewCell.reuseIdentifier, for: indexPath) as? GridViewCell else {
            fatalError("cell or item is not available")
        }

        cell.firstName.text = friend.name.firstname()
        cell.surname.text = friend.name.surname()
        if let url = URL(string: friend.thumbnail) {
            cell.imageView.sd_setImage(with: url)
        }
        return cell
    }
}

extension CharacterDetailsViewController: UICollectionViewDelegateFlowLayout {

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
