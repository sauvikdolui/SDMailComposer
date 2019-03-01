//
//  SDMailComposerTableView.swift
//  SDMailComposer
//
//  Created by Sauvik Dolui on 27/02/19.
//  Copyright © 2019 Sauvik Dolui. All rights reserved.
//

import UIKit
import SDMailComposer

class SDMailComposerTableView: UITableViewController {
    
    let recipients = ["toaddress@email.com","example.exam@effective.digital"]
    let cc = ["a@email.com","jaspreet@effective.digital"]
    let bcc = ["bcc@email.com","bcc@effective.digital"]
    let subjectLine = "Subject Line"
    let mailBody = "This is the sample body"
    
    var allClients = MailClientCellModel.getAppModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allClients.count + 1 // last one for Present with preference
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        switch indexPath.row {
        case let index where index < allClients.count :
            cell.imageView?.image = UIImage(named: allClients[index].imageFile)
            cell.textLabel?.text = allClients[index].name
        default:
            cell.textLabel?.text = "Present from preference"
        }
        return cell
    }
 

    // MARK: - Table View Delegate

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != allClients.count ? true : false // Present from preference is not rearrangable
    }
 
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let fromClient = allClients.remove(at: fromIndexPath.row)
        allClients.insert(fromClient, at: to.row)
        print("Modified Sequence = \(allClients)")
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != allClients.count ? true : false // Present from preference is not rearrangable
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !allClients.isEmpty else { return }
        switch indexPath.row {
        case let index where index < allClients.count :
            presentMailClient(allClients[index].client)
        default:
            presentMailClient(allClients.first!.client)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func presentMailClient(_ client: MailClient) {
        
        // 1. Create a mail composer
        var mailComposer = MailComposer( recipients: recipients,
                                         cc: cc,
                                         bcc: bcc,
                                         subject: subjectLine,
                                         body: mailBody)
        // 2. Try to present it
        do {
            try mailComposer.present(client: client, fromApplication: UIApplication.shared,
                                     completion: { (success) in
                    if success {
                        print("Mail Composer was successfully presented")
                    } else {
                        print("Mail Composer presentation error")
                    }
            })
        } catch MailComposerError.installedClientListEmpty {
            print("No mail client was found")
        } catch MailComposerError.openURLGenerationError(let absoluteString) {
            print("Failed to prepare URL from \(absoluteString)")
        } catch MailComposerError.unknown {
            print("Mail Composer Presentation Unknown Error")
        } catch let error {
            print("Mail Composer Presentation Error: \(error.localizedDescription)")
        }
    }
}
