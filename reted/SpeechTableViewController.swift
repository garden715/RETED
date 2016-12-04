//
//  SpeechTableViewController.swift
//  reted
//
//  Created by seojungwon on 2016. 11. 30..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit
import Firebase
import ActionSheetPicker_3_0

private let SpeechTableViewCellIdentifier = "Speech Cell"

class SpeechTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var levelController: UISegmentedControl!
    @IBOutlet weak var clientTable: UITableView!
    
    var videos: [FIRDataSnapshot]! = []
    var speeches : [Speech]! = []
    var filteredSpeeches : [Speech]! = []
    var ref: FIRDatabaseReference!
    var acp : ActionSheetStringPicker!
    var pickerData: [String] = [String]()
    var selectedRate = 0
    
    override func viewDidLoad() {
        
        self.clientTable.register(UINib(nibName: "SpeechTableViewCell", bundle: nil), forCellReuseIdentifier: SpeechTableViewCellIdentifier)
        self.navigationController?.navigationBar.setBottomBorderColor(color: .red, height: 3.0)
        
        super.viewDidLoad()
        
        configureDatabase()
        configureActionSheetStringPicker()
    }
    
    func configureActionSheetStringPicker() {
        pickerData = ["All", "Fascinating", "Informative", "Funny", "Persuasive","Courageous", "Ingenious", "Inspiring", "Beautiful"]
        
        acp = ActionSheetStringPicker.init(title: "", rows: pickerData, initialSelection: selectedRate, doneBlock: {
            picker, index, value in
            self.selectedRate = index
            self.selectedSegmentedController(self)
            return
            
        }, cancel: {
            ActionStringCancelBlock in return
            
        }, origin: self.view)
        
        acp?.toolbarBackgroundColor = UIColor.lightGray
        acp?.toolbarButtonsColor = UIColor.white
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        self.ref.child("speech").observeSingleEvent(of: FIRDataEventType.value, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            let videosEnumerator = snapshot.children
            while let video = videosEnumerator.nextObject() as? FIRDataSnapshot {
                if let videoDict = video.value as? Dictionary<String, AnyObject> {
                    let insertedSpeech = Speech()
                    insertedSpeech.setValuesForKeys(videoDict);
                    strongSelf.videos.append(video)
                    strongSelf.speeches.append(insertedSpeech)
                }
            }
            strongSelf.selectedSegmentedController(strongSelf)
            }, withCancel: { error -> Void in
                print(error.localizedDescription)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectedSegmentedController(_ sender: Any) {
        self.filteredSpeeches.removeAll()
        
        for speech : Speech in self.speeches {
            let grageOfSpeech = speech.grade - 1
            if (levelController.selectedSegmentIndex == grageOfSpeech) &&
                ((self.selectedRate == 0) ||
                    (pickerData.index(of: speech.rated1) ?? 0 == self.selectedRate) ||
                    (pickerData.index(of: speech.rated2) ?? 0 == self.selectedRate)) {
                
                self.filteredSpeeches.append(speech)
            }
        }
        self.clientTable.reloadData()
    }
    
    @IBAction func didTappedFilter(_ sender: Any) {
        acp.show()
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.filteredSpeeches.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.clientTable.dequeueReusableCell(withIdentifier: SpeechTableViewCellIdentifier, for: indexPath) as! SpeechTableViewCell
        
        // Unpack message from Firebase DataSnapshot
        
        let speech : Speech! = self.filteredSpeeches[indexPath.row]
        let name = speech.name as String!
        let title = speech.title as String!
        
        cell.activitytIndicator.startAnimating()
        cell.titleLabel.text = title
        cell.nameLabel.text = name
        cell.thumbnail.image = UIImage(named: "ic_account_circle")
        
        DispatchQueue.global(qos: .background).async {
            let photoURL = speech.img
            let url = URL(string: photoURL)
            let data = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                if data != nil {
                    cell.thumbnail.image = UIImage(data: data!)
                    cell.activitytIndicator.stopAnimating()
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Segues.FpToDetail, sender: filteredSpeeches[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.FpToDetail{
            let vc = segue.destination as! SpeechDetailViewController
            vc.speech = sender as! Speech
        }
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
    
}

extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
