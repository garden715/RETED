//
//  SpeechsViewController.swift
//  reted
//
//  Created by seojungwon on 2016. 10. 14..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit
import Firebase

class SpeechsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            super.viewWillDisappear(true)
//            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            self.alertMessage(_message: "Error signing out: \(signOutError.localizedDescription)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func alertMessage(_message:String) {
        
        let alert = UIAlertController(title: "Alert", message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
