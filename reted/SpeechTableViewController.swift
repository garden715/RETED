//
//  SpeechTableViewController.swift
//  reted
//
//  Created by seojungwon on 2016. 11. 30..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit
import Firebase

private let SpeechTableViewCellIdentifier = "Speech Cell"

class SpeechTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var clientTable: UITableView!
    
    var videos: [FIRDataSnapshot]! = []
    var speeches : [Speech]! = []
    var ref: FIRDatabaseReference!

    fileprivate var _refHandle: FIRDatabaseHandle!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clientTable.register(UINib(nibName: "SpeechTableViewCell", bundle: nil), forCellReuseIdentifier: SpeechTableViewCellIdentifier)
        
        configureDatabase()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.ref.child("speech").removeObserver(withHandle: _refHandle)
    } 
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        _refHandle = self.ref.child("speech").observe(FIRDataEventType.value, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            let videosEnumerator = snapshot.children
            while let video = videosEnumerator.nextObject() as? FIRDataSnapshot {
                if let p = video.value as? Dictionary<String, AnyObject> {
                    let s = Speech()
                    s.setValuesForKeys(p);
                    strongSelf.videos.append(video)
                    strongSelf.speeches.append(s)
                    strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.videos.count-1, section: 0)], with: .automatic)
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.videos.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.clientTable.dequeueReusableCell(withIdentifier: SpeechTableViewCellIdentifier, for: indexPath) as! SpeechTableViewCell
        
        // Unpack message from Firebase DataSnapshot

        let speech : Speech! = self.speeches[indexPath.row]
        let name = speech.name as String!
        let title = speech.title as String!
        
        cell.titleLabel?.text = title
        cell.nameLabel?.text = name
        cell.thumbnail?.image = UIImage(named: "ic_account_circle")
//        if let photoURL = speech.img, let URL = URL(string: photoURL), let data = try? Data(contentsOf: URL) {
//            cell.imageView?.image = UIImage(data: data)
//        }
        return cell
    }
    

    @IBAction func signOut(_ sender: UIBarButtonItem) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func alertMessage(_message:String) {
        let alert = UIAlertController(title: "Alert", message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
