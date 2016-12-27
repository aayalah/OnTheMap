//
//  EditViewController.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/20/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import UIKit
import MapKit


class EditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var findMapButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    let geocoder = CLGeocoder()
    let userModel = UserModel.sharedInstance()
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var locationView: UIStackView!

    @IBOutlet weak var mapStackView: UIStackView!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    var delegate: ModalDismissal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findMapButton.layer.cornerRadius = 4
        submitButton.layer.cornerRadius = 4
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelAddingLocation(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func addLocation(_ sender: UIButton) {
        var error: String? = nil
        if let url = urlTextField.text{
            if isValidUrl(url: url) {
                userModel.addLocation(latitude:  Float(map.annotations[0].coordinate.latitude), longitude:  Float(map.annotations[0].coordinate.longitude), url: url, mapString: locationTextField.text!) { success, error in
                    performUIUpdatesOnMain{
                        if success {
                            self.delegate?.didDismissView()
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                    }
                }
            } else {
                error = "Please Enter a valid url!"
                present(ControllerConstants.displayError(error: error)!, animated: true)
            }
            
        } else {
            error = "Please Enter a url!"
            present(ControllerConstants.displayError(error: error)!, animated: true)
            
            
        }
    }
    
    private func isValidUrl(url: String) -> Bool{
        guard let url = URL(string: url) else { return false }
        guard UIApplication.shared.canOpenURL(url) else {
            return false
        }
        return true
    }
    
    @IBAction func calculateLocation(_ sender: UIButton) {
        var error: String? = nil
        if let location = locationTextField.text {
            geocoder.geocodeAddressString(location) { (placemarks, error) in
          
                if error != nil {
                    self.present(ControllerConstants.displayError(error: "Location You Entered is Invalid.")!, animated: true)
                } else {

                    let coordinates = (placemarks?[0].location?.coordinate)!
                    self.map.addAnnotation(MKPlacemark(coordinate: coordinates, addressDictionary: placemarks?[0].addressDictionary as! [String : Any]?))
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: coordinates, span: span)
                    
                    self.map.setRegion(region, animated: true)
                    self.displayLocationView()
                }
            }
        } else {
            error = "Please Enter A Location!"
            present(ControllerConstants.displayError(error: error)!, animated: true)
        }
        
    }
    
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func displayLocationView() {
        
        locationView.isHidden = true
        mapStackView.isHidden = false
        submitButton.isHidden = false
    }

}
