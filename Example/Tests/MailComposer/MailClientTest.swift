//
//  MailClientTest.swift
//  TestTests
//
//  Created by Sauvik Dolui on 20/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import XCTest
import SDMailComposer


class MailClientTest: XCTestCase {

    let recipients = ["toaddress@email.com","example.exam@effective.digital"]
    let cc = ["a@email.com","jaspreet@effective.digital"]
    let bcc = ["bcc@email.com","bcc@effective.digital"]
    let subjectLine = "Subject Line"
    let mailBody = "This is the sample body"
    
    var allMailClients: [MailClient] = []
    var allMailClientTypes: [MailClientType] = []
    
    override func setUp() {
        allMailClientTypes = MailClientType.allCases
        allMailClients = MailClientType.allCases.map { $0.client }
    }

    func test_MailClient_Type_Name(){
        XCTAssertTrue(AppleMail().name == MailClientType.appleMail.name, "Mail Client Type Name must be same what used for initialization")
        XCTAssertTrue(Gmail().name == MailClientType.gmail.name, "Mail Client Type Name must be same what used for initialization")
        XCTAssertTrue(YahooMail().name == MailClientType.yahooMail.name, "Mail Client Type Name must be same what used for initialization")
        XCTAssertTrue(YahooMail().name == MailClientType.yahooMail.name, "Mail Client Type Name must be same what used for initialization")
        
    }
    func test_MailClient_Scheme() {

        for mailType in allMailClientTypes {
            let mailClient = mailType.client
            
            switch mailType {
            case .appleMail:
                XCTAssertTrue(mailClient.scheme == "mailto:", "Mail Client Scheme Name must be same what used for initialization")
            case .gmail:
                XCTAssertTrue(mailClient.scheme == "googlegmail:", "Mail Client Scheme Name must be same what used for initialization")
            case .yahooMail:
                XCTAssertTrue(mailClient.scheme == "ymail:", "Mail Client Scheme Name must be same what used for initialization")
            case .msOutlook:
                XCTAssertTrue(mailClient.scheme == "ms-outlook:", "Mail Client Scheme Name must be same what used for initialization")
            }
            
        }
    }
    func test_MailClient_URLRoot() {
        
        for mailType in allMailClientTypes {
            let mailClient = mailType.client
            
            switch mailType {
            case .appleMail:
                XCTAssertTrue(mailClient.urlRoot == "", "Apple Mail URL Root Mismatch")
            case .gmail:
                XCTAssertTrue(mailClient.urlRoot == "///co", "Gmail Mail URL Root Mismatch")
            case .yahooMail:
                XCTAssertTrue(mailClient.urlRoot == "//mail/compose", "Yahoo Mail URL Root Mismatch")
            case .msOutlook:
                XCTAssertTrue(mailClient.urlRoot == "//compose", "Outlook Mail URL Root Mismatch")
            }
        }
    }
    func test_MailClient_RecipientKey(){
        for mailType in allMailClientTypes {
            let mailClient = mailType.client
            
            switch mailType {
            case .appleMail:
                XCTAssertNil(mailClient.urlRecipientKey, "Apple Mail Recipient Key must be nil")
            case .gmail, .yahooMail, .msOutlook:
                XCTAssertTrue(mailClient.urlRecipientKey == "to", "Gmail, Yahoo Mail, Outllok must have \"to\" as recipient key")
            }
        }
    }
    func test_MailClient_CCKey(){
        for mailType in allMailClientTypes {
            let mailClient = mailType.client
            XCTAssertTrue(mailClient.urlCCKey == "cc", "Mail Client CC URL key must be cc")
        }
    }
    func test_MailClient_BCCKey(){
        for mailType in allMailClientTypes {
            let mailClient = mailType.client
            XCTAssertTrue(mailClient.urlBCCKey == "bcc", "Mail Client URL BCC key must be bcc")
        }
    }
    func test_MailClient_SubjectKey(){
        for mailType in allMailClientTypes {
            let mailClient = mailType.client
            XCTAssertTrue(mailClient.urlSubjectKey == "subject", "Mail Client URL Subject key must be subject")
        }
    }
    func test_MailClient_BodyKey_iOS_Mail(){
        for mailType in allMailClientTypes {
            let mailClient = mailType.client
            XCTAssertTrue(mailClient.urlBodyKey == "body", "Mail Client subject key must be body")
        }
    }
    func test_MailClient_RecipientQuery(){
        
        let joinedRecipients = recipients.joined(separator: ",")
        
        for mailType in allMailClientTypes {
            let mailClient = mailType.client
            
            switch mailType {
            case .appleMail:
                XCTAssertTrue(mailClient.getQueryFor(recipients: recipients) == joinedRecipients, "Apple Mail Recipient Key must be empty")
            case .gmail, .yahooMail, .msOutlook:
                XCTAssertTrue(mailClient.getQueryFor(recipients: recipients) == "to" + "=" + joinedRecipients, "Gmail, Yahoo Mail, Outllok recipient list preparation error")
            }
        }
    }
    
    
    func test_MailClient_CCQuery_All_Mail(){
        
        let ccQuery = "cc" + "=" + cc.joined(separator: ",")
        for client in allMailClients {
            let ccQueryFromClient = client.getQueryFor(CCList: cc)
            XCTAssertTrue(ccQueryFromClient == ccQuery, "Mail Client cc query is not as per expectation")
        }
    }
    
    func test_MailClient_BCCQuery_All_Mail(){
        
        let bccQuery = "bcc" + "=" + bcc.joined(separator: ",")
        for client in allMailClients {
            let bccQueryFromClient = client.getQueryFor(BCCList: bcc)
            XCTAssertTrue(bccQueryFromClient == bccQuery, "Mail Client bcc query is not as per expectation")
        }
    }
    func test_MailClient_SubjectQuery_All_Mail(){
        
        let subjectQuery = "subject" + "=" + (subjectLine.urlQueryEncoded ?? "")
        for client in allMailClients {
            let query = client.getQueryFor(subject: subjectLine)
            XCTAssertTrue(query == subjectQuery, "Mail Client subject query is not as per expectation")
        }
    }
    func test_MailClient_BodyQuery_All_Mail(){
        
        let bodyQuery = "body" + "=" + (mailBody.urlQueryEncoded ?? "")
        for client in allMailClients {
            let query = client.getQueryFor(body: mailBody)
            XCTAssertTrue(query == bodyQuery, "Mail Client body query is not as per expectation")
        }
    }
    
    func test_MailClient_CCQuery_All_Mail_Nil_Value(){
        for client in allMailClients {
            XCTAssertNil(client.getQueryFor(CCList: nil), "CC query must be nil for nil cc component")
        }
    }
    func test_MailClient_BCCQuery_All_Mail_Nil_Value(){
        for client in allMailClients {
            XCTAssertNil(client.getQueryFor(BCCList: nil), "BCC query must be nil for nil bcc component")
        }
    }
    func test_MailClient_SubjectQuery_All_Mail_Nil_Value(){
        for client in allMailClients {
            XCTAssertNil(client.getQueryFor(subject: nil), "BCC query must be nil for nil bcc component")
        }
    }
    func test_MailClient_BodyQuery_All_Mail_Nil_Value(){
        for client in allMailClients {
            XCTAssertNil(client.getQueryFor(body: nil), "Body query must be nil for nil body component")
        }
    }
    

    

    // Test Scheme Matching TestO
    func test_scheme_generation(){
        for clientType in allMailClientTypes {
            let client = clientType.client
            switch clientType {
            case .appleMail:
                XCTAssertTrue(client.scheme == "mailto:", "\(client.name) Scheme mismatch Error")
            case .gmail:
                XCTAssertTrue(client.scheme == "googlegmail:", "\(client.name) Scheme mismatch Error")
            case .yahooMail:
                XCTAssertTrue(client.scheme == "ymail:", "\(client.name) Scheme mismatch Error")
            case .msOutlook:
                XCTAssertTrue(client.scheme == "ms-outlook:", "\(client.name) Scheme mismatch Error")
            }
        }
    }
    // Test Scheme Matching Test
    func test_root_url_generation(){
        for clientType in allMailClientTypes {
            let client = clientType.client
            switch clientType {
            case .appleMail:
                XCTAssertTrue(client.urlRoot == "", "\(client.name) Scheme mismatch Error")
            case .gmail:
                XCTAssertTrue(client.urlRoot == "///co", "\(client.name) Scheme mismatch Error")
            case .yahooMail:
                XCTAssertTrue(client.urlRoot == "//mail/compose", "\(client.name) Scheme mismatch Error")
            case .msOutlook:
                XCTAssertTrue(client.urlRoot == "//compose", "\(client.name) Scheme mismatch Error")
            }
        }
    }
    
    func test_base_url_generation(){
        
        for clientType in allMailClientTypes {
            let client = clientType.client
            switch clientType {
            case .appleMail:
                XCTAssertTrue(client.baseURL == "mailto:", "\(client.name) Base URL generation Error")
            case .gmail:
                XCTAssertTrue(client.baseURL == "googlegmail:///co", "\(client.name) Base URL generation Error")
            case .yahooMail:
                XCTAssertTrue(client.baseURL == "ymail://mail/compose", "\(client.name) Base URL generation Error")
            case .msOutlook:
                XCTAssertTrue(client.baseURL == "ms-outlook://compose", "\(client.name) Base URL generation Error")
            }
        }
    }
    
    // Check final URL for Apple Mail
    func test_final_url_generation_apple_mail_no_recipient_no_cc_no_bcc_no_subject_no_body(){
        let mailClient = MailClientType.appleMail.client
        do {
            let url = try mailClient.getFinalURL(recipients: nil, cc: nil, bcc: nil, subject: nil, body: nil)
            XCTAssert(url.absoluteString == "mailto:", "URL Generation issue")
        } catch let error {
             XCTFail("error is not expected \(error.localizedDescription)")
        }
    }
    func test_final_url_generation_apple_mail_single_recipient_no_cc_no_bcc_no_subject_no_body(){
        let mailClient = MailClientType.appleMail.client
        do {
            let url = try mailClient.getFinalURL(recipients: ["example.exam@effective.digital"], cc: nil, bcc: nil, subject: nil, body: nil)
            XCTAssert(url.absoluteString == "mailto:example.exam@effective.digital", "URL Generation issue")
        } catch let error {
            XCTFail("error is not expected \(error.localizedDescription)")
        }
    }
    func test_final_url_generation_apple_mail_more_recipient_no_cc_no_bcc_no_subject_no_body(){
        let mailClient = MailClientType.appleMail.client
        do {
            let url = try mailClient.getFinalURL(recipients: ["example.exam@effective.digital", "jowiejr@irwf.com"], cc: nil, bcc: nil, subject: nil, body: nil)
            XCTAssert(url.absoluteString == "mailto:example.exam@effective.digital,jowiejr@irwf.com", "URL Generation issue")
        } catch let error {
            XCTFail("error is not expected \(error.localizedDescription)")
        }
    }
    func test_final_url_generation_apple_mail_valid_invalid_recipient_no_cc_no_bcc_no_subject_no_body(){
        let mailClient = MailClientType.appleMail.client
        do {
            let url = try mailClient.getFinalURL(recipients: ["example.exam", "jowiejr@irwf.com"], cc: nil, bcc: nil, subject: nil, body: nil)
            XCTAssert(url.absoluteString == "mailto:jowiejr@irwf.com", "URL Generation issue")
        } catch let error {
            XCTFail("error is not expected \(error.localizedDescription)")
        }
    }
    func test_final_url_generation_apple_mail_all_invalid_recipient_no_cc_no_bcc_no_subject_no_body(){
        let mailClient = MailClientType.appleMail.client
        do {
            let url = try mailClient.getFinalURL(recipients: ["example.exam", "jowiejr@uwef"], cc: nil, bcc: nil, subject: nil, body: nil)
            XCTAssert(url.absoluteString == "mailto:", "URL Generation issue")
        } catch let error {
            XCTFail("error is not expected \(error.localizedDescription)")
        }
    }
    func test_final_url_generation_apple_mail_valid_invalid_recipient_with_cc_no_bcc_no_subject_no_body(){
        let mailClient = MailClientType.appleMail.client
        do {
            let url = try mailClient.getFinalURL(recipients: ["example.exam", "jowiejr@irwf.com"], cc: ["example.exam", "jowiejr@irwf.com"], bcc: nil, subject: nil, body: nil)
            XCTAssert(url.absoluteString == "mailto:jowiejr@irwf.com?cc=jowiejr@irwf.com", "URL Generation issue")
        } catch let error {
            XCTFail("error is not expected \(error.localizedDescription)")
        }
    }
    func test_final_url_generation_apple_mail_valid_recipients_with_cc_with_bcc_no_subject_no_body(){
        let mailClient = MailClientType.appleMail.client
        do {
            let url = try mailClient.getFinalURL(recipients: ["example.exam", "jowiejr@irwf.com"],
                                                 cc: ["example.exam", "jowiejr@irwf.com"],
                                                 bcc: ["example.exam@gmail.com", "jowiejr@irwf.com"],
                                                 subject: nil, body: nil)
            XCTAssert(url.absoluteString == "mailto:jowiejr@irwf.com?cc=jowiejr@irwf.com&bcc=example.exam@gmail.com,jowiejr@irwf.com", "URL Generation issue")
        } catch let error {
            XCTFail("error is not expected \(error.localizedDescription)")
        }
    }
    func test_final_url_generation_apple_mail_valid_recipients_with_cc_with_bcc_with_subject_no_body(){
        let mailClient = MailClientType.appleMail.client
        let subject = "This is subject line"
        
        do {
            let url = try mailClient.getFinalURL(recipients: ["jowiejr@irwf.com"],
                                                 cc: ["example.exam", "jowiejr@irwf.com"],
                                                 bcc: ["example.exam@gmail.com", "jowiejr@irwf.com"],
                                                 subject: subject, body: nil)
            XCTAssert(url.absoluteString == "mailto:jowiejr@irwf.com?cc=jowiejr@irwf.com&bcc=example.exam@gmail.com,jowiejr@irwf.com&subject=\(subject.urlQueryEncoded!)" , "URL Generation issue")
        } catch let error {
            XCTFail("error is not expected \(error.localizedDescription)")
        }
    }
    
    func test_final_url_generation_apple_mail_valid_recipients_with_cc_with_bcc_with_subject_with_body(){
        let mailClient = MailClientType.appleMail.client
        let subject = "This is subject line"
        let body = "This is simple body"
        
        do {
            let url = try mailClient.getFinalURL(recipients: ["jowiejr@irwf.com"],
                                                 cc: ["example.exam", "jowiejr@irwf.com"],
                                                 bcc: ["example.exam@gmail.com", "jowiejr@irwf.com"],
                                                 subject: subject, body: body)
            XCTAssert(url.absoluteString == "mailto:jowiejr@irwf.com?cc=jowiejr@irwf.com&bcc=example.exam@gmail.com,jowiejr@irwf.com&subject=\(subject.urlQueryEncoded!)&body=\(body.urlQueryEncoded!)" , "URL Generation issue")
        } catch let error {
            XCTFail("error is not expected \(error.localizedDescription)")
        }
    }
    
    // Check final URL for Apple Mail
    func test_final_url_generation_other_mail_no_recipient_no_cc_no_bcc_no_subject_no_body(){
        
        let mailClients = MailClientType.allCases.filter{ $0 != .appleMail }.map { $0.client }
        for client in mailClients {
            do {
                let url = try client.getFinalURL(recipients: nil, cc: nil, bcc: nil, subject: nil, body: nil)
                XCTAssert(url.absoluteString == client.baseURL, "URL Generation issue for \(client.name)")
            } catch let error {
                XCTFail("error is not expected \(error.localizedDescription)")
            }
        }
    }
    // Check final URL for Other Mails
    func test_final_url_generation_other_mail_single_valid_recipient_no_cc_no_bcc_no_subject_no_body(){
        
        let mailClients = MailClientType.allCases.filter{ $0 != .appleMail }.map { $0.client }
        let recipients = ["sauvik@b.com"]
        let expectedSuffix = "?to=sauvik@b.com"
        
        for client in mailClients {
            do {
                let url = try client.getFinalURL(recipients: recipients, cc: nil, bcc: nil, subject: nil, body: nil)
                XCTAssert(url.absoluteString == client.baseURL + expectedSuffix, "URL Generation issue for \(client.name)")
            } catch let error {
                XCTFail("error is not expected \(error.localizedDescription)")
            }
        }
    }
    
    // Check final URL for Other Mails
    func test_final_url_generation_other_mail_valid_invalid_recipient_no_cc_no_bcc_no_subject_no_body(){
        
        let mailClients = MailClientType.allCases.filter{ $0 != .appleMail }.map { $0.client }
        let recipients = ["sauvik@b.com", "iuhweoihr@ijwe"]
        let expectedSuffix = "?to=sauvik@b.com"
        
        for client in mailClients {
            do {
                let url = try client.getFinalURL(recipients: recipients, cc: nil, bcc: nil, subject: nil, body: nil)
                XCTAssert(url.absoluteString == client.baseURL + expectedSuffix, "URL Generation issue for \(client.name)")
            } catch let error {
                XCTFail("error is not expected \(error.localizedDescription)")
            }
        }
    }
    // Check final URL for Other Mails
    func test_final_url_generation_other_mail_valid_recipient_with_cc_no_bcc_no_subject_no_body(){
        
        let mailClients = MailClientType.allCases.filter{ $0 != .appleMail }.map { $0.client }
        let recipients = ["sauvik@b.com", "iuhweoihr@ijwe"]
        let cc = ["sauvik@b.com", "iuhweoihr@ijwe"]
        let expectedSuffix = "?to=sauvik@b.com&cc=sauvik@b.com"
        
        for client in mailClients {
            do {
                let url = try client.getFinalURL(recipients: recipients, cc: cc, bcc: nil, subject: nil, body: nil)
                XCTAssert(url.absoluteString == client.baseURL + expectedSuffix, "URL Generation issue for \(client.name)")
            } catch let error {
                XCTFail("error is not expected \(error.localizedDescription)")
            }
        }
    }
    // Check final URL for Other Mails
    func test_final_url_generation_other_mail_valid_recipient_with_cc_with_bcc_no_subject_no_body(){
        
        let mailClients = MailClientType.allCases.filter{ $0 != .appleMail }.map { $0.client }
        let recipients = ["sauvik@b.com", "iuhweoihr@ijwe"]
        let cc = ["sauvik@b.com", "iuhweoihr@ijwe"]
        let bcc = ["sauvik@b.comwfrwr", "iuhweoihr@ijwe.comower"]
        let expectedSuffix = "?to=sauvik@b.com&cc=sauvik@b.com&bcc=sauvik@b.comwfrwr,iuhweoihr@ijwe.comower"
        
        for client in mailClients {
            do {
                let url = try client.getFinalURL(recipients: recipients, cc: cc, bcc: bcc, subject: nil, body: nil)
                XCTAssert(url.absoluteString == client.baseURL + expectedSuffix, "URL Generation issue for \(client.name)")
            } catch let error {
                XCTFail("error is not expected \(error.localizedDescription)")
            }
        }
    }
    // Check final URL for Other Mails
    func test_final_url_generation_other_mail_valid_recipient_with_cc_with_bcc_with_subject_no_body(){
        
        let mailClients = MailClientType.allCases.filter{ $0 != .appleMail }.map { $0.client }
        let recipients = ["sauvik@b.com", "iuhweoihr@ijwe"]
        let cc = ["sauvik@b.com", "iuhweoihr@ijwe"]
        let bcc = ["sauvik@b.comwfrwr", "iuhweoihr@ijwe.comower"]
        let subject = "This is sample subject line"
        let expectedSuffix = "?to=sauvik@b.com&cc=sauvik@b.com&bcc=sauvik@b.comwfrwr,iuhweoihr@ijwe.comower&subject=" + subject.urlQueryEncoded!
        
        for client in mailClients {
            do {
                let url = try client.getFinalURL(recipients: recipients, cc: cc, bcc: bcc, subject: subject, body: nil)
                XCTAssert(url.absoluteString == client.baseURL + expectedSuffix, "URL Generation issue for \(client.name)")
            } catch let error {
                XCTFail("error is not expected \(error.localizedDescription)")
            }
        }
    }
    
    func test_final_url_generation_other_mail_valid_recipient_with_cc_with_bcc_with_subject_with_body(){
        
        let mailClients = MailClientType.allCases.filter{ $0 != .appleMail }.map { $0.client }
        let recipients = ["sauvik@b.com", "iuhweoihr@ijwe"]
        let cc = ["sauvik@b.com", "iuhweoihr@ijwe"]
        let bcc = ["sauvik@b.comwfrwr", "iuhweoihr@ijwe.comower"]
        let subject = "This is sample subject line"
        let body = "This is sample body content"
        let expectedSuffix = "?to=sauvik@b.com&cc=sauvik@b.com&bcc=sauvik@b.comwfrwr,iuhweoihr@ijwe.comower&subject=" + subject.urlQueryEncoded! + "&" + "body=" + body.urlQueryEncoded!
        
        for client in mailClients {
            do {
                let url = try client.getFinalURL(recipients: recipients, cc: cc, bcc: bcc, subject: subject, body: body)
                XCTAssert(url.absoluteString == client.baseURL + expectedSuffix, "URL Generation issue for \(client.name)")
            } catch let error {
                XCTFail("error is not expected \(error.localizedDescription)")
            }
        }
    }
    
}
