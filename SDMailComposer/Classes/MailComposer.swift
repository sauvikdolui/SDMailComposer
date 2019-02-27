//
//  MailComposer.swift
//  Test
//
//  Created by Sauvik Dolui on 19/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import Foundation

/// Mail Composing Errors
///
/// - unknown: unknown error
/// - openURLGenerationError: Error while preparing URL using available scheme. The absolute on which the URL was to be prepared is returened
/// - clientNotInstalled: Mail client is not installed on the device
/// - installedClientListEmpty: Single client is not installed from following the preference list
public enum MailComposerError: Error {
    case unknown
    case openURLGenerationError(String)
    case clientNotInstalled (String)
    case installedClientListEmpty
}


/// Every `MailComposer` needs to conform to `MailComposerProtocol`
public protocol MailComposerProtocol {
    
   
    /// List of email ids as `[String]` for recipients
    var recipients: [String]? { get set }
    /// List of email ids as `[String]` for carbon copies
    var cc: [String]? { get set }
    /// List of email ids as `[String]` for blind carbon copies
    var bcc: [String]? { get set }
    /// Subject line for mail composer
    var subjectLine: String? { get set }
    // Body content of the mail composer
    var body: String? { get set }

    
    /// Initializes a mail composer with optional recipients, cc bcc list, subject and body
    ///
    /// - Parameters:
    ///   - recipient: List of recipients
    ///   - cc: List of email ids to be placed in CC
    ///   - bcc: List of email ids to be placed in BCC
    ///   - subject: The subject line of the mail
    ///   - body: Body of the mail
    init(recipients: [String]?, cc: [String]?, bcc: [String]?, subject: String?, body: String?)
    
    /// Function to check the availability of a client installed on current device
    ///
    /// - Parameters:
    ///   - client: Mail client to chec
    ///   - application: Application from which the mail client will be presented
    /// - Returns: returns `true` or `false` based on availability
    static func isClient(_ client: MailClient, availableFor application: UIApplicationMailComposer) -> Bool
    
}


/// Contains the functions to be conformed by a `MailComposer` to present the composer
public protocol MailComposerUI {
    /// Present the mail composer for a specific mail client
    ///
    /// - Parameters:
    ///   - client: The client (`AppleMail`, `Yahoo Mail`, 'Ms-Outlook', "Gmail") which is to be used for composing mail
    ///   - application: The application from which the composer is to be presented
    ///   - completion: Completion block to be executed after presentation is successful
    /// - Throws: Can throw `MailComposerError.clientNotInstalled(String)` exception if client is not installed
    mutating func present(client: MailClient, fromApplication application: UIApplicationMailComposer, completion: @escaping ((Bool) -> Void)) throws
    
    /// Presents a mail composer with a preference list of mail client type.
    ///
    /// - Note:
    /// Present the first available client from the list `clientPreference`
    ///
    /// - Parameters:
    ///   - clientPreference: List of `MailClientType` as the preference list
    ///   - application: The application which is to be used to present the composer
    ///   - completion: Completion Block to be executed once the composer is presented successfully
    /// - Throws: Can throw `MailComposerError.installedClientListEmpty` is installed client list is empty
    mutating func present(clientPreference: [MailClientType], fromApplication application: UIApplicationMailComposer, completion: @escaping ((Bool) -> Void)) throws
}

/// Mail Composer is a structure working as a wrapper above several mail clients
/// available on iOS. Currently it supports
///  1. iOS Mail
///  2. MS-Outlook
///  3. Gmail
///  4. Yahoo Mail
///
/// - Note: To add support for other mail clients please update `MailClient` 
///
public struct MailComposer: MailComposerProtocol {
    
    /// A list of recipients as an array of `EmailID`
    public var recipients: [String]?
    
    /// list of `EmailID`s which are to be placed in Carbon Copy
    public var cc: [String]? // not settable from outside
    
    /// list of `EmailID`s which are to be placed in Blind Carbon Copy
    public var bcc: [String]? // not settable from outside
    
    /// The subject line of the mail
    public var subjectLine: String? // not settable from outside
    // The body content of the mail
    public var body: String? // not settable from outside
    
    /// Initializes a mail composer with optional recipients, cc bcc list, subject and body
    ///
    /// - Parameters:
    ///   - recipient: List of recipients
    ///   - cc: List of email ids to be placed in CC
    ///   - bcc: List of email ids to be placed in BCC
    ///   - subject: The subject line of the mail
    ///   - body: Body of the mail
    public init(recipients: [String]? = nil,
         cc: [String]? = nil,
         bcc: [String]? = nil,
         subject: String? = nil,
         body: String? = nil) {
        
        self.recipients = recipients
        self.cc = cc
        self.bcc = bcc
        self.subjectLine = subject
        self.body = body
    }
    
    
    /// Function to check the availability of a client installed on current device
    ///
    /// - Parameters:
    ///   - client: Mail client to chec
    ///   - application: Application from which the mail client will be presented
    /// - Returns: returns `true` or `false` based on availability
    static public func isClient(_ client: MailClient, availableFor application: UIApplicationMailComposer) -> Bool {
        guard let url = URL(string: client.baseURL) else { return false }
        return application.canOpenURL(url)
    }
}
