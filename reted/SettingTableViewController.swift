//
//  SettingTableViewController.swift
//  reted
//
//  Created by seojungwon on 2016. 12. 6..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit
import MessageUI

let developerEmails = ["garden715@gmail.com"]
let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

class SettingTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var versionDetailLabel: UILabel!

    override func viewDidLoad() {
        versionDetailLabel.text = appVersion
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

       
    }
    
    func mail(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(developerEmails)
        composeVC.setSubject(NSLocalizedString("SUBJECT_OF_MAIL", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: ""))
        composeVC.setMessageBody("", isHTML: false)
        
        // Present the view controller modally.
        composeVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(composeVC, animated: true, completion: nil)
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.mail(self)
            }
        } else if indexPath.section == 1{
            if indexPath.row == 1 {
                self.performSegue(withIdentifier: Constants.Segues.SettingToLicenses, sender: nil)
            }
            return
        }
    }
}
