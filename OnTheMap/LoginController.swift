//
//  LoginController.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerLink: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        stackView.addArrangedSubview(loginButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginController.goToLink))
        registerLink.isUserInteractionEnabled = true
        registerLink.addGestureRecognizer(tap)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print(result.token.tokenString)
        ParseClient.sharedInstance().authenticateViaFacebook(token: result.token.tokenString) { success, error in
            performUIUpdatesOnMain{
                if success {
                    self.loginResult()
                } else {
                        FBSDKLoginManager().logOut()
                        self.present(ControllerConstants.displayError(error: "Was not able to login. Problem with the connection.")!, animated: true)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func goToLink(sender: UITapGestureRecognizer) {
        
      
        if let myURL = URL(string: ControllerConstants.registerURL) {
            UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
        }

    }
    
    
    @IBAction func attemptLogin(_ sender: UIButton) {
        
        if let email = emailField.text, let password = passwordField.text {
            ParseClient.sharedInstance().authenticateViaUdacity(userName: email, passWord: password){ success, error in
                performUIUpdatesOnMain{
                    if success {
                        self.loginResult()
                    } else {
                        if error!.code == 1 {
                            self.present(ControllerConstants.displayError(error: "Was not able to login. Problem with the connection.")!, animated: true)
                        } else {
                            self.present(ControllerConstants.displayError(error: "Was not able to login. Either your user name or password is incorrect.")!, animated: true)
                        }
                        
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func loginResult() {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    
}
