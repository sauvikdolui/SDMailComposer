//
//  String+MailComposer.swift
//  Test
//
//  Created by Sauvik Dolui on 19/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import Foundation


// MARK: - Mail Composer Query Extension

// String extension which will be used for adding
// functionalities to `String` type
public extension String {
    
    /// Percent encoded version of a string
    ///
    /// `"Hello World"` becomes `"Hello%20World"`
    ///
    ///  ```
    ///  "Hello World".urlQueryEncoded
    ///  // Hello%20World
    ///  ```
    /// - SeeAlso:
    ///     [Percent Encoding](https://en.wikipedia.org/wiki/Percent-encoding)
    ///
    var urlQueryEncoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    /// Check whether a string is a valid emaid id
    var isValidEmail: Bool { return ValidityChecker.isValid(regexType: .email, value: self) }
}
