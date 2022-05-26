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
}

