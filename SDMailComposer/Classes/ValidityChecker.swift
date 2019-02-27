//
//  ValidityChecker.swift
//  Test
//
//  Created by Sauvik Dolui on 19/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import Foundation


/// Regular Expression Types
///
/// These types will be used to attach a regular expression with a specific type of string
///
/// - email: Regular expression for specific type of string data
public enum RegularExpressionType: String {
    /// Regualar for email id
    case email = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
}


/// A struct to check validity of a string against a specific regular expression type
public struct ValidityChecker {
    
    /// Checks validation of a string against a specific type of value i.e. email, password, phone number
    ///
    /// - Parameters:
    ///   - regexType: Regular expression type
    ///   - value: The string which is to be checked
    /// - Returns: true OR false based on validation check result
    static func isValid(regexType: RegularExpressionType, value: String) -> Bool {
        guard let regularExpression = try? NSRegularExpression(pattern: regexType.rawValue,
                                                               options: .caseInsensitive) else { return false }
        let matchCount = regularExpression.numberOfMatches(in: value,
                                                           options: .reportCompletion,
                                                           range: NSRange(location: 0, length: value.count))
        return matchCount > 0
    }
}
