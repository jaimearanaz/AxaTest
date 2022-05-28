//
//  Box.swift
//
//  Created by Jaime Aranaz on 23/12/2021.
//  Copyright © 2017 Jaime Aranaz. All rights reserved.
//

import Foundation

// @see https://www.toptal.com/ios/swift-tutorial-introduction-to-mvvm
class Box<T> {
    
    typealias Listener = (T) -> ()
    var listeners = [Listener]()
    
    func bind(_ listener: Listener?) {
        if let listener = listener {
            self.listeners.append(listener)
        }
    }
    
    func bindAndFire(_ listener: Listener?) {
        if let listener = listener {
            self.listeners.append(listener)
        }
        _ = self.listeners.map({
            $0(value)
        })
    }
    
    func unbindAll() {
        listeners = [Listener]()
    }
    
    var value: T {
        didSet {
            _ = self.listeners.map({
                $0(value)
            })
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
