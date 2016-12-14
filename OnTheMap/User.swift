//
//  User.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import Foundation

class UserModel {
    
    private struct Singleton {
        static let User_Model = UserModel()

    }
    
    private var users = [User]()
    

    
    func requestListOfUsers(updateUI: @escaping (_ success: Bool) -> Void) {
        
        let limit = 500
        let skip = 0
        
        paginateResults(limit: limit, skip: skip, updateUI: updateUI)
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
    
    private func paginateResults(limit: Int, skip: Int, updateUI: @escaping (_ success: Bool) -> Void) {
        
        ParseClient.sharedInstance().getStudentsLocations(limit: limit, skip: skip, storeResult: resultToModel) { success, error in
            if success == true {
                self.paginateResults(limit: limit, skip: skip + limit, updateUI: updateUI)
            } else {
                updateUI(true)
            }
            
        }

        
    }
    
    
    private func resultToModel(result: AnyObject?) -> Bool {
        
        if let result = result as? [String:AnyObject] {
            
            let userArray = result[ParseClient.JSONResponseKeys.locBodyKey] as! [AnyObject]
            if userArray.count == 0 {
                return false
            }
            for user in userArray {
                users.append(parseUser(user: user))
            }
            return true
        }
        return false
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
            return User(firstName: firstName, lastName: lastName, key: key, location: mapString, url: mediaURL, longitude: latitude, latitude: longitude)
        }
        return user as! User
    }
  
    class func sharedInstance() ->  UserModel {
        return Singleton.User_Model
    }

    
    
    
}


class User {
    
    let firstName: String
    let lastName: String
    let key: String
    let location: String
    let url: String
    let lat: Float
    let lon: Float
    
    init(firstName fName: String, lastName lName: String, key: String, location loc: String, url: String, longitude lon: Float, latitude lat: Float) {
        firstName = fName
        lastName = lName
        self.key = key
        location = loc
        self.url = url
        self.lon = lon
        self.lat = lat
        
    }
    
    func getName() -> String {
        return "\(firstName) \(lastName)"
    }
    
}

