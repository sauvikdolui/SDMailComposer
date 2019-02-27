//
//  MailCoposer+UI.swift
//  Test
//
//  Created by Sauvik Dolui on 20/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import Foundation

// MARK: Extension which deals with UI Component
extension MailComposer: MailComposerUI {
    
    /// Opens the mail composer of it's `client.type.name`
    ///
    /// - Parameter completion: Presentation completion block
    /// - Throws: Throws error
    ///     * `MailComposerError.openURLGenerationError(_)` if `openURL` is not well formed
    ///     * `MailComposerError.clientNotInstalled()` if cliet is not installed on the current device
    public mutating func present(client: MailClient, fromApplication application: UIApplicationMailComposer, completion: @escaping ((Bool) -> ())) throws {
        
 
        let openURL = try client.getFinalURL(recipients: self.recipients, cc: cc, bcc: bcc, subject: subjectLine, body: body)
        guard application.canOpenURL(openURL) else { throw MailComposerError.clientNotInstalled(client.name) }
        application.openMailURL(openURL) { (success) in
            // Executing completion block
            completion(success)
        }

    }
    
    /// Presents a mail composer with a preference list of mail client type.
    ///
    /// - Note:
    /// Present the first available client from the list `clientPreference`
    ///
    /// - Parameters:
    ///   - clientPreference: List of `MailClientType` as the preference list
    ///   - application: The application which is to be used to present the composer
    ///   - completion: Completion Block to be executed once the composer is presented successfully
    /// - Throws: Throws error
    ///     * `MailComposerError.openURLGenerationError(_)` if `openURL` is not well formed
    ///     * `MailComposerError.clientNotInstalled()` if cliet is not installed on the current device
    public mutating func present(clientPreference: [MailClientType], fromApplication application: UIApplicationMailComposer, completion: @escaping ((Bool) -> ())) throws {
        
        // Checking mail client availability
        let installedClients = clientPreference.map { $0.client }.filter { MailComposer.isClient($0, availableFor: application) }
            
        guard !installedClients.isEmpty else {
            throw MailComposerError.installedClientListEmpty
        }
        // Present the composer with first client
        try present(client: installedClients.first!, fromApplication: application, completion: completion)
    }
}
