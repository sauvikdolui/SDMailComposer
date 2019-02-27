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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        var imageFile = ""
        var clientName = ""
        switch indexPath.row {
        case 0:
            imageFile = "AppleMail"
            clientName = "Apple Mail"
        case 1:
            imageFile = "OutlookMail"
            clientName = "MS Outlook"
        case 2:
            imageFile = "Gmail"
            clientName = "Gmail"
        case 3:
            imageFile = "YahooMail"
            clientName = "Yahoo Mail"
        default:
            cell.textLabel?.text = "Present from preference"
            return cell
        }

        cell.imageView?.image = UIImage(named: imageFile)
        cell.textLabel?.text = clientName
        return cell
    }
 


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 4 ? true : false // Present from preference is not rearrangable
    }
 
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 4 ? true : false // Present from preference is not rearrangable
    }
 

}
