//
//  MailComposerDeviceTest.swift
//  TestTests
//
//  Created by Sauvik Dolui on 22/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import XCTest
import SDMailComposer


class MailComposerDeviceTest: XCTestCase {

    var allMailClients: [MailClient] = []
    var allMailClientTypes: [MailClientType] = []
    
    override func setUp() {
        allMailClientTypes = MailClientType.allCases
        allMailClients = MailClientType.allCases.map { $0.client }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }



}
