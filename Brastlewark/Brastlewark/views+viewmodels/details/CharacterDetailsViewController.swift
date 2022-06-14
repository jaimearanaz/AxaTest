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
    
    @IBOutlet weak var avatarView: AvatarImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var ageLb: UILabel!
    @IBOutlet weak var weightLb: UILabel!
    @IBOutlet weak var heightLb: UILabel!
    @IBOutlet weak var hairColorLb: UILabel!
    @IBOutlet weak var professionsLb: UILabel!
    @IBOutlet weak var friendsLb: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
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
            DispatchQueue.main.async {
                self.configCharacter(character)
            }
        })
        
        viewModel?.errorMessage.bind({ errorMessage in
            DispatchQueue.main.async {
                self.showAlert(withMessage: errorMessage)
            }
        })
        
        viewModel?.transitionTo.bind({ transitionTo in
            DispatchQueue.main.async {
                if let transitionTo = transitionTo {
                    self.performTransition(to: transitionTo)
                }
            }
        })
    }
    
    override func customizeView() {
        
        super.customizeView()
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< \("BACK_TO_GRID".localized)",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectBack))
        friendsLb.font = UIFont.black_18()
        friendsLb.text = "CHARACTER_FRIENDS".localized
        
        let nib = UINib.init(nibName: FriendViewCell.className, bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: FriendViewCell.reuseIdentifier)
        tableView?.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView?.bounds.width ?? 0, height: 0))
        tableView?.tableFooterView = UIView()
        tableView?.separatorColor = UIColor.clear
    }
    
    @objc func didSelectBack() {
        viewModel?.didSelectBack()
    }
    
    @objc func didSelectMyButton() {
        print("")
    }
    
    private func performTransition(to transitionTo: CharacterDetailsTransitions) {
        
        switch transitionTo {
        case .toGrid:
            navigationController?.popToRootViewController(animated: true)
        default:
            self.performSegue(withIdentifier: transitionTo.rawValue, sender: self)
        }
    }

    private func configCharacter(_ character: CharacterDetailsUi) {
        
        if let url = URL(string: character.thumbnail) {
            avatarView.setImage(withUrl: url)
        }
        
        nameLb.font = UIFont.special_20()
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
        
        friendsLb.isHidden = character.friends.isEmpty
        tableView?.reloadData()
    }
    
    private func attributedSection(title: String, value: String) -> NSAttributedString {
        
        let string = "\(title): \(value)"
        let attributedString = NSMutableAttributedString(string: string)
        
        let titleRange = NSRange(location: 0, length: title.count + 1)
        let titleAttributes = [NSAttributedString.Key.font: UIFont.black_18()]
        attributedString.addAttributes(titleAttributes, range: titleRange)

        let valueRange = NSRange(location: titleRange.length, length: value.count)
        let valueAttributes = [NSMutableAttributedString.Key.font: UIFont.regular_16()]
        attributedString.addAttributes(valueAttributes, range: valueRange)

        return attributedString.withLineSpacing(8)
    }
}
