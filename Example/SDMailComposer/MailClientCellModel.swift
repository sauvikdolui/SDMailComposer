//
//  MailClientCellModel.swift
//  SDMailComposer_Example
//
//  Created by Sauvik Dolui on 27/02/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import SDMailComposer

struct MailClientCellModel {
    
    let imageFile: String
    let name: String
    let client: MailClient
    
    init(clientType: MailClientType) {
        
        self.client = clientType.client
        
        switch self.client.type {
        case .appleMail:
            imageFile = "AppleMail"
        case .gmail:
            imageFile = "Gmail"
        case .yahooMail:
            imageFile = "YahooMail"
        case .msOutlook:
            imageFile = "OutlookMail"
        }
        name = client.name
    }
    
    static func getAppModels() -> [MailClientCellModel] {
        return [
            MailClientCellModel(clientType: .appleMail),
            MailClientCellModel(clientType: .gmail),
            MailClientCellModel(clientType: .yahooMail),
            MailClientCellModel(clientType: .msOutlook),
        ]
    }
}
