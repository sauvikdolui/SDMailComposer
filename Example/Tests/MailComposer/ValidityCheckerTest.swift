//
//  ValidityCheckerTest.swift
//  TestTests
//
//  Created by Sauvik Dolui on 20/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import XCTest
import SDMailComposer

class ValidityCheckerTest: XCTestCase {
    
    func test_Valid_Email(){

        for email in validEmails {
            XCTAssertTrue(ValidityChecker.isValid(regexType: .email, value: email), "Email must be a valid one")
        }
        
    }
    func test_Invalid_Email(){

        for email in invalidEmails {
            XCTAssertFalse(ValidityChecker.isValid(regexType: .email, value: email), "Email must be an invalid one")
        }
    }
}
