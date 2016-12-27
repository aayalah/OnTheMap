//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/13/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class TableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, ModalDismissal{
    @IBOutlet weak var tableView: UITableView!
    
    let userModel = UserModel.sharedInstance()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "edit"){
            let controller = segue.destination as! EditViewController
            controller.delegate = self
        }
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        getUsers()
        tableView.reloadData()
    }
    
    @IBAction func logout(_ sender: Any) {
        ParseClient.sharedInstance().deleteSession { success, error in
            performUIUpdatesOnMain {
                if success {
                    FBSDKLoginManager().logOut()
                    self.performSegue(withIdentifier: "logout", sender: nil)
                }
            }
        }
    }
    
    
    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        userModel.getUserInfo { success, error in
            if success {
                self.getLocation()
            } else {
                performUIUpdatesOnMain {
                    self.present(ControllerConstants.displayError(error: "Could not get user info")!, animated: true)
                }
            }
        }
        
    }
    
    
    private func getLocation() {
        userModel.getUserLocation { success, error in
            
            performUIUpdatesOnMain {
                
                if success {
                    
                    let alertController = UIAlertController(title: "Warning", message: "A location already exists. Do you want to overwrite it?", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok",style: UIAlertActionStyle.default) { action in
                        self.performSegue(withIdentifier: "edit", sender: nil)
                    })
                    alertController.addAction(UIAlertAction(title: "Cancel",style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alertController, animated: true)
                } else {
                    self.performSegue(withIdentifier: "edit", sender: nil)
                }
                
            }
            
            
        }
        
    }
    
    func didDismissView() {
        getUsers()
    }
    
    private func getUsers() {
        
        userModel.requestListOfUsers(){ success in
            performUIUpdatesOnMain{
                if success {
                   self.tableView.reloadData()
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userModel.getNumberUsers()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel!.text = userModel.getUsers(index: indexPath.row).getName()
        // Configure the cell...

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let myURL = URL(string: userModel.getUsers(index: indexPath.row).getURL()) {
         UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
    }
        
    
}
    

}
