//
//  Constants.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//
import UIKit
struct ControllerConstants {
    
    static let registerURL = "https://www.udacity.com/"
    static func displayError(error: String?) -> UIAlertController? {
        
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok",style: UIAlertActionStyle.cancel, handler: nil))
            return alertController
        }
        return nil
        
    }
    
    
    
}
