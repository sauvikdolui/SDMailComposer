//
//  UIApplication+MailComposer.swift
//  Test
//
//  Created by Sauvik Dolui on 25/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import Foundation
import UIKit


/// Public protocol to be confirmed to open a mail composer
public protocol UIApplicationMailComposer {
    
    /// Checks whether an URL from `LSApplicationQueriesSchemes` can be opened
    ///
    /// - Parameter url: The URL which is to be opened
    /// - Returns: `true` or `false` based on it's availability
    func canOpenURL(_ url: URL) -> Bool
    func openMailURL(_ url: URL, completionHandler: ((Bool) -> Void)?)
}

// MARK: - `UIApplication` conforming to `UIApplicationMailComposer`
extension UIApplication: UIApplicationMailComposer {
    public func openMailURL(_ url: URL, completionHandler: ((Bool) -> Void)?) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: completionHandler)
        } else {
            openURL(url)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
