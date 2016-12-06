//
//  ViewController.swift
//  reted
//
//  Created by seojungwon on 2016. 10. 10..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!

    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
        // Sign In with credentials.
        self.loginActivityIndicator.startAnimating()
        guard let email = emailField.text, let password = passwordField.text else {
            return }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.alertMessage(_message: error.localizedDescription)
                self.loginActivityIndicator.stopAnimating()
                return
            }
            self.loginActivityIndicator.stopAnimating()
            self.signedIn(user!)
        }
    }
    @IBAction func didTapSignUp(_ sender: AnyObject) {
        self.loginActivityIndicator.startAnimating()
        guard let email = emailField.text, let password = passwordField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.alertMessage(_message: error.localizedDescription)
                self.loginActivityIndicator.stopAnimating()
                return
            }
            self.loginActivityIndicator.stopAnimating()
            self.setDisplayName(user!)
        }
    }

    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func setDisplayName(_ user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                self.alertMessage(_message: error.localizedDescription)
                return
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    
    @IBAction func didRequestPasswordReset(_ sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: NSLocalizedString("EMAIL", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: NSLocalizedString("OK", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: ""), style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    self.alertMessage(_message: error.localizedDescription)
                    return
                }
            }
        }
        let cancelAction = UIAlertAction.init(title: NSLocalizedString("CANCEL", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: ""), style: .cancel, handler: nil)
        
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        prompt.addAction(cancelAction)
        
        present(prompt, animated: true, completion: nil);
    }
    
    func signedIn(_ user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.signedIn = true
        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
        self.emailField.text?.removeAll()
        self.passwordField.text?.removeAll()
    }
    
    func alertMessage(_message:String) {
        
        let alert = UIAlertController(title: NSLocalizedString("CAUTION", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: ""), message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("CONFIRM", tableName: "GroupOfStrings", bundle: Bundle.main, value: "", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

}
