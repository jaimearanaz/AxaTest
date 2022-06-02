//
//  FriendsTableController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 2/6/22.
//

import Foundation
import UIKit

extension CharacterDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let friend = viewModel?.character.value.friends[safe: indexPath.row] {
            viewModel?.didSelectFriend(id: friend.id)
        }
    }
}

extension CharacterDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FriendViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.character.value.friends.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let friend = viewModel?.character.value.friends[safe: indexPath.item],
              let cell = tableView.dequeueReusableCell(withIdentifier: FriendViewCell.reuseIdentifier, for: indexPath) as? FriendViewCell else {
            fatalError("cell or item is not available")
        }

        cell.setupCell(friend: friend)
        return cell
    }
}
