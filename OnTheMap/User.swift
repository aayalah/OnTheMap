//
//  User.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import Foundation
import MapKit

class UserModel {
    
    private struct Singleton {
        static let User_Model = UserModel()

    }
    

    
    private var users = [User]()
    private var currentUser = CurrentUser()
    
    func getUserInfo(completionHandler: @escaping (Bool, NSError?) -> Void) {
        if currentUser.getFirstName() == nil {
            ParseClient.sharedInstance().getStudentInfo(uniqueKey: currentUser.getKey()!, storeResult: currentUserToModel, completionHandler: completionHandler)
        } else {
            completionHandler(true,nil)
        }
    }


    func getUserLocation(completionHandler: @escaping (Bool, NSError?) -> Void) {
        if currentUser.getObjectId() == nil {
            ParseClient.sharedInstance().getStudentLocation(uniqueKey: currentUser.getKey()!, storeResult: existingLocationToModel, completionHandler: completionHandler)
        } else {
            completionHandler(true, nil)
        }
    }
    
    func requestListOfUsers(updateUI: @escaping (_ success: Bool) -> Void) {
        
        paginateResults(limit: ParseClient.ClassesGetParameters.limitAmount, skip: ParseClient.ClassesGetParameters.skipAmount, updateUI: updateUI)
    }
    
    func addLocation(latitude: Float, longitude: Float, url: String, mapString: String, completionHandler: @escaping (Bool, NSError?) -> Void) {
        if currentUser.getObjectId() != nil {
        
            ParseClient.sharedInstance().putStudentLocation(uniqueKey: currentUser.getKey()!, firstName: currentUser.getFirstName()!, lastName: currentUser.getLastName()!, mapString: mapString, mediaURL: url, latitude: latitude, longitude: longitude, objectId: currentUser.getObjectId()!, completionHandler: completionHandler)
            
        } else {
            
            ParseClient.sharedInstance().postStudentLocation(uniqueKey: currentUser.getKey()!, firstName: currentUser.getFirstName()!, lastName: currentUser.getLastName()!, mapString: mapString, mediaURL: url, latitude: latitude, longitude: longitude, completionHandler: completionHandler)
            
        }
        
        
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func getUsers(index: Int) -> User {
        return users[index]
    }
    
    func getNumberUsers() -> Int {
        return users.count
    }
    
    func getCurrentUser() -> CurrentUser {
        return currentUser
    }
    
    private func paginateResults(limit: Int, skip: Int, updateUI: @escaping (_ success: Bool) -> Void) {
        
        ParseClient.sharedInstance().getStudentsLocations(limit: limit, skip: skip, storeResult: userListResultToModel) { success, error in
            updateUI(success)
            
        }

        
    }
    
    
    private func userListResultToModel(result: AnyObject?) -> Bool {
        
        users = parseUserObject(result: result)
        return users.count != 0
        
    }
    
    private func currentUserToModel(result: AnyObject?) -> Bool {
        if let result = result as? [String: AnyObject] {
            
            if let user = result[ParseClient.JSONResponseKeys.infoBodyKey] as? [String: AnyObject] {
                currentUser.setFirstName(name: (user[ParseClient.JSONResponseKeys.first_name] as? String)!)
                currentUser.setLastName(name: (user[ParseClient.JSONResponseKeys.last_name] as? String)!)
                return true
            }
        }
        return false
        
    }

    private func existingLocationToModel(result: AnyObject?) -> Bool {
        let user = parseUserObject(result: result)
        currentUser.setObjectID(id: user[0].getObjectId())
        return user.count != 0
    }


    
    private func parseUserObject(result: AnyObject?) -> [User] {
        var resultArray = [User]()
        if let result = result as? [String:AnyObject] {
            
            let userArray = result[ParseClient.JSONResponseKeys.locBodyKey] as! [AnyObject]
            if userArray.count == 0 {
                return resultArray
            }
            for user in userArray {
                resultArray.append(parseUser(user: user))
            }
            return resultArray
        }
        return resultArray
    }
    
    
    private func parseUser(user: AnyObject) -> User {
        
        if let user = user as? [String:AnyObject] {
            let firstName = user[ParseClient.JSONResponseKeys.firstName] as? String ?? ""
            let lastName = user[ParseClient.JSONResponseKeys.lastName] as? String ?? ""
            let key = user[ParseClient.JSONResponseKeys.uniqueKey] as? String ?? ""
            let mapString = user[ParseClient.JSONResponseKeys.mapString] as? String ?? ""
            let mediaURL = user[ParseClient.JSONResponseKeys.mediaURL] as? String ?? ""
            let latitude = user[ParseClient.JSONResponseKeys.latitude] as? Float ?? 0
            let longitude = user[ParseClient.JSONResponseKeys.longitude] as? Float ?? 0
            let objectId = user[ParseClient.JSONResponseKeys.objectId] as? String ?? ""
            print(mapString)
            print(latitude)
            print(longitude)
            return User(firstName: firstName, lastName: lastName, key: key, location: mapString, url: mediaURL, longitude: longitude, latitude: latitude, objectId: objectId)
        }
        return user as! User
    }
    
  
    class func sharedInstance() ->  UserModel {
        return Singleton.User_Model
    }

    
    
    
}


class User: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    
    
    private let firstName: String
    private let lastName: String
    private let key: String
    private let location: String
    private let url: String
    private let lat: Float
    private let lon: Float
    private let objectId: String
    
    init(firstName fName: String, lastName lName: String, key: String, location loc: String, url: String, longitude lon: Float, latitude lat: Float, objectId: String) {
        firstName = fName
        lastName = lName
        self.key = key
        location = loc
        self.url = url
        self.lon = lon
        self.lat = lat
        self.objectId = objectId
        
        self.title = "\(firstName) \(lastName)"
        self.subtitle = self.url
        self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.lat), longitude: CLLocationDegrees(self.lon))
        
    }
    
    func getObjectId() -> String {
        return objectId
    }
    
    func getURL() -> String {
        return self.url
    }
    
    func getName() -> String {
        return "\(firstName) \(lastName)"
    }
    
    func getFirstName() -> String {
        return "\(firstName)"
    }
    
    func getLastName() -> String {
        return "\(lastName)"
    }
    
    func getKey() -> String {
        return "\(key)"
    }
    

    
}

class CurrentUser {
    private var firstName: String? = nil
    private var lastName: String? = nil
    private var key: String? = nil
    private var objectId: String? = nil
    
    init() {
        
    }
    
    init(lastName: String, firstName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func setFirstName(name:String) {
        firstName = name
    }
    
    func setLastName(name:String) {
        lastName = name
    }
    
    func setKey(val: String) {
        key = val
    }
    
    func getFirstName() -> String? {
        return firstName
    }
    
    func getLastName() -> String?
    {
        return lastName
    }
    
    func getKey() -> String? {
        return key
    }
    
    func setObjectID(id: String) {
        objectId = id
    }
    
    func getObjectId() -> String? {
        return objectId
    }
}
