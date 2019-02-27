//
//  MailComposerTest.swift
//  TestTests
//
//  Created by Sauvik Dolui on 22/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import XCTest

import SDMailComposer


class MailComposerTest: XCTestCase {

    let recipients = ["example.exam@iojwe.com", "ouehwor@ijwe"]
    let cc = ["example.exam@iojwe.com", "ouehwor@ijwe"]
    let bcc = ["example.exam@iojwe.com", "ouehwor@ijwe"]
    let subject = "This is sample subject line"
    let body = "This is sample body content"
    let nilParamComposer = MailComposer()
    var fullParamComposer: MailComposer!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fullParamComposer = MailComposer(recipients: recipients,
                                         cc: cc,
                                         bcc: bcc,
                                         subject: subject,
                                         body: body)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_mail_composer_initialization_with_client_type() {
        
        XCTAssertNotNil(nilParamComposer, "Composer must not be nil")
        XCTAssertNil(nilParamComposer.recipients, "Composer recipient list must be nil")
        XCTAssertNil(nilParamComposer.cc, "Composer cc list must be nil")
        XCTAssertNil(nilParamComposer.bcc, "Composer bcc list must be nil")
        XCTAssertNil(nilParamComposer.subjectLine, "Composer subjectline list must be nil")
        XCTAssertNil(nilParamComposer.body, "Composer body list must be nil")
    }
    
    func test_mail_composer_initialization_with_values() {

        XCTAssertTrue(fullParamComposer.recipients == recipients, "Mail Recipients should be valid ones only")
        XCTAssertTrue(fullParamComposer.cc == cc, "Mail CC list should contain valid emails only")
        XCTAssertTrue(fullParamComposer.bcc == bcc, "Mail BCC list should contain valid emails only")
        XCTAssertTrue(fullParamComposer.subjectLine == subject, "Mail subject line must match")
        XCTAssertTrue(fullParamComposer.body == body, "Mail body content must match")
    }

    // MARK: - Availability Checking
    func test_client_availability_on_device() {
        XCTAssertTrue(MailComposer.isClient(AppleMail(), availableFor: UIApplicationMailComposerDeviceMock()), "Apple Mail must be available, it's installed")
        XCTAssertTrue(MailComposer.isClient(Gmail(), availableFor: UIApplicationMailComposerDeviceMock()), "Gmail Mail must be available, it's installed")
        XCTAssertTrue(MailComposer.isClient(YahooMail(), availableFor: UIApplicationMailComposerDeviceMock()), "Yahoo Mail must be available, it's installed")
        XCTAssertTrue(MailComposer.isClient(MSOutlook(), availableFor: UIApplicationMailComposerDeviceMock()), "Outlook Mail must be available, it's installed")
    }
    func test_client_availability_on_simulator() {
        XCTAssertFalse(MailComposer.isClient(AppleMail(), availableFor: UIApplicationMailComposerSimlulatorMock()), "Apple Mail must not be available on simulator")
        XCTAssertFalse(MailComposer.isClient(Gmail(), availableFor: UIApplicationMailComposerSimlulatorMock()), "Gmail Mail must not be available on simulator")
        XCTAssertFalse(MailComposer.isClient(YahooMail(), availableFor: UIApplicationMailComposerSimlulatorMock()), "Yahoo Mail must not be available on simulator")
        XCTAssertFalse(MailComposer.isClient(MSOutlook(), availableFor: UIApplicationMailComposerSimlulatorMock()), "Outlook Mail must not be available on simulator")
    }
    
    // MARK: - Composer presentation testing
    func test_mail_composer_presentation_with_single_client_on_ios_device() {
        let expectation = XCTestExpectation(description: "Mail Composer presentation with single client test on decive")
        var composer = MailComposer(recipients: recipients,
                                         cc: cc,
                                         bcc: bcc,
                                         subject: subject,
                                         body: body)
        do {
            try composer.present(client: Gmail(), fromApplication: UIApplicationMailComposerDeviceMock(), completion: { (success) in
                if success { expectation.fulfill() }
            })
        } catch {
            XCTFail("Must not face any exception while presenting with UIApplicationMailComposerDeviceMock()")
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_mail_composer_presentation_with_preference_on_ios_device() {
        // Need to run test on a real device with atleast one mail client installed from the preference list
        let expectation = XCTestExpectation(description: "Mail Composer presentation with preference list test on decive")
        var composer = MailComposer(recipients: recipients,
                                    cc: cc,
                                    bcc: bcc,
                                    subject: subject,
                                    body: body)
        
        do {
            try composer.present(clientPreference: [.appleMail, .gmail, .msOutlook, .yahooMail],
                                          fromApplication: UIApplicationMailComposerDeviceMock()) { (success) in
                if success { expectation.fulfill() }
            }
        } catch {
            XCTFail("Must not face any exception while presenting with UIApplicationMailComposerDeviceMock()")
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_mail_composer_presentation_with_single_client_on_ios_simulator() {

        // Need to run test on a real device with atleast one mail client installed from the preference list
        let expectation = XCTestExpectation(description: "Mail Composer presentation with preference list test on decive")

        var composer = MailComposer(recipients: recipients,
                                    cc: cc,
                                    bcc: bcc,
                                    subject: subject,
                                    body: body)
        
        do {
            try composer.present(client: AppleMail(), fromApplication: UIApplicationMailComposerSimlulatorMock(), completion: { (success) in
                XCTFail("Simulator do not have any mail client installed")
            })
    
        } catch MailComposerError.clientNotInstalled(let clientName) {
            if clientName == AppleMail().name { expectation.fulfill() }
        } catch {
            XCTFail("Must not face any exception while presenting with UIApplicationMailComposerDeviceMock()")
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_mail_composer_presentation_with_preference_list_of_client_on_ios_simulator() {
        
        // Need to run test on a real device with atleast one mail client installed from the preference list
        let expectation = XCTestExpectation(description: "Mail Composer presentation with preference list test on decive")
        
        var composer = MailComposer(recipients: recipients,
                                    cc: cc,
                                    bcc: bcc,
                                    subject: subject,
                                    body: body)
        
        do {
            try composer.present(clientPreference: [.appleMail, .gmail, .msOutlook, .yahooMail],
                                 fromApplication: UIApplicationMailComposerSimlulatorMock()) { (success) in
                    XCTFail("Simulator does not have any mail client installed")
            }
            
        } catch MailComposerError.installedClientListEmpty {
             expectation.fulfill()
        } catch {
            XCTFail("Must not face any exception while presenting with UIApplicationMailComposerDeviceMock()")
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
}


