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
    func canOpenURL(_ url: URL) -> Bool {
        return true
    }
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler: ((Bool) -> Void)?) {
        completionHandler?(true)
    }
}
struct UIApplicationMailComposerSimlulatorMock: UIApplicationMailComposer {
    func canOpenURL(_ url: URL) -> Bool {
        return false
    }
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler: ((Bool) -> Void)?) {
        completionHandler?(false)
    }
}
