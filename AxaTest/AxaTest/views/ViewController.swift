//
//  ViewController.swift
//  AxaTest
//
//  Created by Jaime Aranaz on 26/5/22.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let baseUrl = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
        let networkRepository = NetworkRepository(baseUrl: baseUrl)

        networkRepository.getCharacters()
            .sink { completion in
                
                switch completion {
                case .finished:
                    print("Success!!")
                case .failure(let error):
                    print(error.localizedDescription)
                    print("There was an error")
                }
                
            } receiveValue: { characters in

                print(characters)
            }
            .store(in: &subscribers)
    }

    private func getFilterValues(fromCharacters characters: [Character]) {
        
        var professions = Set<String>()
        var hairColors = Set<String>()
        
        characters.forEach ({
            $0.professions.forEach { professions.insert($0) }
            hairColors.insert($0.hairColor)
        })
        
        let minAge = characters.min { $0.age < $1.age }?.age
        let maxAge = characters.max { $0.age < $1.age }?.age
        
        let minWeight = characters.min { $0.weight < $1.weight }?.weight
        let maxWeight = characters.max { $0.weight < $1.weight }?.weight
        
        let minHeight = characters.min { $0.height < $1.height }?.height
        let maxHeight = characters.max { $0.height < $1.height }?.height
    }

    private func filter(characters: [Character]) -> [Character] {
        
        let hairColors = ["Black", "White", "Red", "Gray", "Red", "Pink" ]
        let professions = ["Stonecarver", "Tinker", "Carpenter", "Brewer", "Farmer"]
        let selectedHairColors: [String] = [String]()
        let selectedProfessions = ["Tinker", "Carpenter", "Brewer"]

        let filtered = characters
            .filter { (1...50).contains($0.age) }
            .filter { (1...500).contains($0.weight) }
            .filter { (1...500).contains($0.height) }
            .filter ({
                if selectedHairColors.isEmpty {
                    return true
                } else {
                    return selectedHairColors.contains($0.hairColor)
                }
            })
            .filter ({
                if selectedProfessions.isEmpty {
                    return true
                } else {
                    let professionsSet = Set($0.professions)
                    let selectedProfessionsSet = Set(selectedProfessions)
                    let inBoth = professionsSet.intersection(selectedProfessionsSet)
                    return inBoth.isNotEmpty
                }
            })
        
        return filtered
    }
}

