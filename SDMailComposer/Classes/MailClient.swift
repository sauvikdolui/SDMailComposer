//
//  MailClient.swift
//  Test
//
//  Created by Sauvik Dolui on 20/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import Foundation


/// Mail Client Type for Email
public enum MailClientType: CaseIterable {
    /// iOS Mail
    case appleMail
    /// Microsoft's Outlook
    case msOutlook
    /// Gmail
    case gmail
    /// Yahoo Mail
    case yahooMail
    
    /// Name associated with type of `MailClientType`
    public var name: String {
        switch self {
        case .appleMail:            return "Apple Mail"
        case .msOutlook:            return "Outlook"
        case .gmail:                return "Gmail"
        case .yahooMail:            return "Yahoo Mail"
        }
    }
    
    /// The client associated with `MailClientType`
    public var client: MailClient {
        switch self {
        case .appleMail:            return AppleMail()
        case .msOutlook:            return MSOutlook()
        case .gmail:                return Gmail()
        case .yahooMail:            return YahooMail()
        }
    }
}


/// Mail client for iOS
public struct AppleMail: MailClient {
    
    /// Type of mail client, it is `.appleMail`
    public var type: MailClientType { return .appleMail }
    /// Scheme of the Mail Client to open
    public var scheme: String { return "mailto:" }
    /// `urlRoot` of the Mail Client to be appended after scheme
    public var urlRoot: String { return "" }
    /// `urlRecipientKey` of Apple Mail, it `nil`
    public var urlRecipientKey: String? { return nil }
    
    
    /// Creates a final URL to present the `MailComposer`
    ///
    /// - Parameters:
    ///   - recipients: List of email ids for recipients
    ///   - cc: List of email ids for cc
    ///   - bcc: List of email ids for bcc
    ///   - subject: Subject of the mail composer
    ///   - body: Body of the mail composer
    /// - Returns: URL of to open the
    /// - Throws: `MailComposerError.openURLGenerationError()` if url generation failed
    public func getFinalURL(recipients: [String]?, cc: [String]?, bcc: [String]?, subject: String?, body: String?) throws -> URL {
        
        var urlString = ""
        
        let queryList: [String] = [
            getQueryFor(CCList: cc),
            getQueryFor(BCCList: bcc),
            getQueryFor(subject: subject),
            getQueryFor(body: body),
            ].compactMap { $0 }
        
        if queryList.isEmpty {
            // Query List is empty, no cc, no bcc, no body and subject
            urlString = baseURL + (getQueryFor(recipients: recipients) ?? "")
        } else {
            urlString = baseURL + (getQueryFor(recipients: recipients) ?? "") + "?" + queryList.compactMap {$0}.joined(separator: "&")
        }
        guard let url = URL(string: urlString) else { throw MailComposerError.openURLGenerationError(urlString) }
        return url
    }

}


/// Microsoft's Outlook mail client
public struct MSOutlook: MailClient {
    /// Type of mail client, it is `.msOutlook`
    public var type: MailClientType { return .msOutlook}
    /// Scheme of the Mail Client to open
    public var scheme: String { return "ms-outlook:" }
    /// `urlRoot` of the Mail Client to be appended after scheme
    public var urlRoot: String { return "//compose" }
}

/// Google's mail client
public struct Gmail: MailClient {
    /// Type of mail client, it is `.yahooMail`
    public var type: MailClientType { return .gmail}
    /// Scheme of the Mail Client to open
    public var scheme: String { return "googlegmail:" }
    /// `urlRoot` of the Mail Client to be appended after scheme
    public var urlRoot: String { return "///co" }
}


/// Yahoo's mail client
public struct YahooMail: MailClient {
    /// Type of mail client, it is `.yahooMail`
    public var type: MailClientType { return .yahooMail}
    /// Scheme of the Mail Client to open
    public var scheme: String { return "ymail:" }
    /// `urlRoot` of the Mail Client to be appended after scheme
    public var urlRoot: String { return "//mail/compose" }
}


// MARK: - Mail client Default Implementation
/// Default implementation of the mail client
public extension MailClient {
    
    /// Base URL (`scheme` + `urlRoot`)
    var baseURL: String { return scheme + urlRoot }
    /// Name of the mail client
    var name: String { return type.name }
    
    /// Key to be used for recipients
    public var urlRecipientKey: String? { return "to" }
    /// Key to be used for CC list
    public var urlCCKey: String? { return "cc" }
    /// Key to be used for BCC list
    public var urlBCCKey: String? { return "bcc" }
    /// Key to be used for subject
    public var urlSubjectKey: String? { return "subject" }
    /// Key to be used for body
    public var urlBodyKey: String? { return "body" }
    
    
    
    /// Prepares url query for recipient list
    ///
    /// - Parameter recipients: List of email ids as `[String]`
    /// - Returns: url query for recipient list
    func getQueryFor(recipients: [String]?) -> String? {
        guard let list = recipients  else { return nil }
        guard let key = urlRecipientKey else { return list.filter { $0.isValidEmail }.joined(separator: ",") }
        return key + "=" + list.filter { $0.isValidEmail }.joined(separator: ",")
    }
    /// Prepares url query for CC list
    ///
    /// - Parameter CCList: List of email ids as `[String]`
    /// - Returns: url query for CC list
    func getQueryFor(CCList: [String]?) -> String? {
        guard let list = CCList, let key = urlCCKey else { return nil }
        return key + "=" + list.filter { $0.isValidEmail }.joined(separator: ",")
    }
    /// Prepares url query for BCC list
    ///
    /// - Parameter BCCList: List of email ids as `[String]`
    /// - Returns: url query for BCC list
    func getQueryFor(BCCList: [String]?) -> String? {
        guard let list = BCCList, let key = urlBCCKey else { return nil }
        return key + "=" + list.filter {$0.isValidEmail}.joined(separator: ",")
    }
    
    /// Prepares query for subject line
    ///
    /// - Parameter subject: Subject line of the mail composer
    /// - Returns: subject line query for URL
    func getQueryFor(subject: String?) -> String? {
        guard let percentEncodedValue = subject?.urlQueryEncoded else { return nil }
        return subject != nil && urlSubjectKey != nil ? urlSubjectKey! + "=" + percentEncodedValue : nil
    }
    
    /// Prepares query for body
    ///
    /// - Parameter body: body content to be added in the body component
    /// - Returns: Query for body component
    func getQueryFor(body: String?) -> String? {
        guard let percentEncodedValue = body?.urlQueryEncoded else { return nil }
        return body != nil && urlBodyKey != nil ? urlBodyKey! + "=" + percentEncodedValue : nil
    }
    
    /// Prepares the final URL to be provided to a `UIApplicationMailComposer`
    ///
    /// - Parameters:
    ///   - recipients: Email id list as recipients
    ///   - cc: Email id list as cc
    ///   - bcc: Email id list as bcc
    ///   - subject: Subject line
    ///   - body:  Body of the mail composer
    /// - Returns: URL to be passed to 'UIApplicationMailComposer' to present the mail client
    /// - Throws: `MailComposerError.openURLGenerationError()` if url is misformed
    func getFinalURL(recipients: [String]?, cc: [String]?, bcc: [String]?, subject: String?, body: String?) throws -> URL {
        let queryList: [String] = [
            getQueryFor(recipients: recipients),
            getQueryFor(CCList: cc),
            getQueryFor(BCCList: bcc),
            getQueryFor(subject: subject),
            getQueryFor(body: body),
        ].compactMap {$0}
        
        var urlString = baseURL
        if !queryList.isEmpty  {
            urlString += "?" + queryList.joined(separator: "&")
        }
        // FIXME: BCC list on yahoo mail is not working
        guard let url = URL(string: urlString) else { throw MailComposerError.openURLGenerationError(baseURL) }
        return url
    }

    
}

/// URLKey will be used to present a key in the URL
public typealias URLKey = String

public protocol MailClient {
    
    var type: MailClientType { get }
    
    var name: String { get }
    var scheme: String { get }
    var urlRoot: String { get }
    
    var urlRecipientKey: URLKey? { get }
    var urlCCKey: URLKey? { get }
    var urlBCCKey: URLKey? { get }
    var urlSubjectKey: URLKey? { get }
    var urlBodyKey: URLKey? { get }
    
    var baseURL: String { get }
    
    func getFinalURL(recipients: [String]?, cc: [String]?, bcc: [String]?, subject: String?, body: String?) throws -> URL
    
}
