//
//  ViewController.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit

class MapViewController: UIViewController, MKMapViewDelegate, ModalDismissal {
    
    @IBOutlet weak var mapView: MKMapView!
    let userModel = UserModel.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()

        
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        getUsers()
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
                    self.mapView.addAnnotations(self.getPins())
                }
            }
            
        }
    }
    

    private func getPins() -> [MKAnnotation]{
        
        let users = userModel.getUsers()
        return users
        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        
        ParseClient.sharedInstance().deleteSession { success, error in
            performUIUpdatesOnMain {
                if success {
                    FBSDKLoginManager().logOut()
                    self.performSegue(withIdentifier: "logout", sender: nil)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? User {
            
            let identifier = "user"
            var view = MKPinAnnotationView()
            if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: "user") as? MKPinAnnotationView {
                dequedView.annotation = annotation
                view = dequedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
            }
            return view
            
        }
        
        return nil
 
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "edit"){
            let controller = segue.destination as! EditViewController
            controller.delegate = self
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let view = view.annotation as? User, let myURL = URL(string: view.getURL()) {
                UIApplication.shared.open(myURL, options: [:], completionHandler: nil)
        }
    }
    
    
    


}

