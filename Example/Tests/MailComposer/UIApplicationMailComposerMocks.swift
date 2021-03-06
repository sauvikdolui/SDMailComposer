//
//  UIApplicationMailComposerMocks.swift
//  TestTests
//
//  Created by Sauvik Dolui on 25/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import Foundation
import UIKit
import SDMailComposer

struct UIApplicationMailComposerDeviceMock: UIApplicationMailComposer {
    
    func openMailURL(_ url: URL, completionHandler: ((Bool) -> Void)?) {
        completionHandler?(true)
    }
    
    func canOpenURL(_ url: URL) -> Bool {
        return true
    }
}
struct UIApplicationMailComposerSimlulatorMock: UIApplicationMailComposer {
    func canOpenURL(_ url: URL) -> Bool {
        return false
    }
    func openMailURL(_ url: URL, completionHandler: ((Bool) -> Void)?) {
        if canOpenURL(url) && completionHandler != nil { completionHandler!(true) }
    }
}
