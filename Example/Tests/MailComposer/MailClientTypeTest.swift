//
//  MailClientTypeTest.swift
//  TestTests
//
//  Created by Sauvik Dolui on 20/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import XCTest
import SDMailComposer

class MailClientTypeTest: XCTestCase {
    
    func test_all_cases_count_check(){
        XCTAssertTrue(MailClientType.allCases.count == 4, "Number of total cases must be 4")
    }
    func test_name_for_types(){
        let clientNames = [
            "Apple Mail",
            "MS Outlook",
            "Gmail",
            "Yahoo Mail"
        ]
        for (name, clientType) in zip(clientNames, MailClientType.allCases) {
            XCTAssertTrue(clientType.name == name, "Email Client name did not match")
        }
    }

}
