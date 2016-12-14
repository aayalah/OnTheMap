//
//  LoginController.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
 
    @IBAction func attemptLogin(_ sender: UIButton) {
        
        if let email = emailField.text, let password = passwordField.text {
            print(ParseClient.sharedInstance())
            ParseClient.sharedInstance().authenticateViaUdacity(userName: email, passWord: password){ success, error in
                performUIUpdatesOnMain{
                    if success {
                        self.loginResult()

                    }
                }
            }
        }
    }
    
    
    private func loginResult() {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    
}
