//
//  ViewController.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let userModel = UserModel.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userModel.requestListOfUsers(){ success in
            performUIUpdatesOnMain{
                if success {
                    self.mapView.addAnnotations(self.getPins())
                    
                }
            }
            
        }

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            }

    private func getPins() -> [MKPointAnnotation]{
        
        let users = userModel.getUsers()
        
        var pins = [MKPointAnnotation]()
        
        for user in users {
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(user.lat), CLLocationDegrees(user.lon))
            
            pins.append(point)
            
        }
        
        return pins
        
    }
    
    func mapView
    
    


}

