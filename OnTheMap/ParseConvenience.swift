//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func authenticateViaUdacity(userName: String, passWord: String, completionHandlerForAuth: @escaping (Bool, NSError?) -> Void){
        
        let parameters = [String: AnyObject]();
        let jsonBody = "{\"\(ParseClient.AuthenticationPostParameters.bodyKey)\": {\"\(ParseClient.AuthenticationPostParameters.username)\": \"\(userName)\",\"\(ParseClient.AuthenticationPostParameters.password)\": \"\(passWord)\"}}"
        _ = taskForPostAuthenticationMethod(ParseClient.Constants.Auth_URL, parameters: parameters, jsonBody: jsonBody) { result, error in
            if error == nil {
                let result = result as! [String: AnyObject]
                let accountObject = result[ParseClient.JSONResponseKeys.account] as! [String: AnyObject]
                self.userModel.getCurrentUser().setKey(val: (accountObject[ParseClient.JSONResponseKeys.key] as? String)!)
                completionHandlerForAuth(true,nil)
            } else {
                completionHandlerForAuth(false, error!)
            }
  
        }
        
        
        
    }
    
    func authenticateViaFacebook(token: String, completionHandlerForAuth: @escaping (Bool, NSError?) -> Void) {
        
        let parameters = [String: AnyObject]();
        let jsonBody = "{\"\(ParseClient.FBAuthenticationPostParameters.bodyKey)\": {\"\(ParseClient.FBAuthenticationPostParameters.accessToken)\": \"\(token)\"}}"
        
        _ = taskForPostAuthenticationMethod(ParseClient.Constants.Auth_URL, parameters: parameters, jsonBody: jsonBody) { result, error in
            if error == nil {
                let result = result as! [String: AnyObject]
                let accountObject = result[ParseClient.JSONResponseKeys.account] as! [String: AnyObject]
                self.userModel.getCurrentUser().setKey(val: (accountObject[ParseClient.JSONResponseKeys.key] as? String)!)
                completionHandlerForAuth(true,nil)
            } else {
                completionHandlerForAuth(false, error!)
            }
            
        }
        
        
    }
    
    
    func getStudentsLocations(limit: Int, skip: Int, storeResult: @escaping (_ result: AnyObject?) -> Bool, completionHandler: @escaping (Bool, NSError?) -> Void) {
       
        var parameters = [ParseClient.ClassesGetParameters.limit : "\(limit)"]
        parameters[ParseClient.ClassesGetParameters.skip] = "\(skip)"
        parameters[ParseClient.ClassesGetParameters.recent] = "-\(ParseClient.ClassesGetParameters.updatedOrder)"
        _ = taskForGetMethod(ParseClient.ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: "") { result, error in
            if error == nil {
                
                completionHandler(storeResult(result), nil)
                
                
            } else {
                completionHandler(false, error!)
            }
            
        }
        
    }
    
    
    func getStudentLocation(uniqueKey: String, storeResult: @escaping (_ result: AnyObject?) -> Bool, completionHandler: @escaping (Bool, NSError?) -> Void) {
        var parameters:[String:AnyObject] = [String:AnyObject]()
        parameters[ParseClient.ClassesGetParameters.where_param] = "{\"\(ParseClient.ClassesGetParameters.uniqueKey)\":\"\(uniqueKey)\"}" as AnyObject?
        
        _ = taskForGetMethod(ParseClient.ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: "") { result, error in
            if error == nil {

                completionHandler(storeResult(result), nil)
                
            } else {
                completionHandler(false, error)
            }
            
        }

        
    }
    
    func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completionHandler: @escaping (Bool, NSError?) -> Void) {
        let parameters:[String:AnyObject] = [String:AnyObject]()
        let jsonBody = "{\"\(ParseClient.ClassesPostParameters.uniqueKey)\": \"\(uniqueKey)\", \"\(ParseClient.ClassesPostParameters.firstName)\": \"\(firstName)\", \"\(ParseClient.ClassesPostParameters.lastName)\": \"\(lastName)\",\"\(ParseClient.ClassesPostParameters.mapString)\": \"\(mapString)\", \"\(ParseClient.ClassesPostParameters.mediaURL)\": \"\(mediaURL)\",\"\(ParseClient.ClassesPostParameters.latitude)\": \(latitude), \"\(ParseClient.ClassesPostParameters.longitude)\": \(longitude)}"

        _ = taskForPostMethod(ParseClient.ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: jsonBody) { result, error in
            if error == nil {
                
                completionHandler(true, nil)
                
            } else {
                completionHandler(false, error)
            }
            
        }
        

    }
    
    //need to fix
    func putStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, objectId: String, completionHandler: @escaping (Bool, NSError?) -> Void) {
        let parameters:[String:AnyObject] = [String:AnyObject]()
        let jsonBody = "{\"\(ParseClient.ClassesPostParameters.uniqueKey)\": \"\(uniqueKey)\", \"\(ParseClient.ClassesPostParameters.firstName)\": \"\(firstName)\", \"\(ParseClient.ClassesPostParameters.lastName)\": \"\(lastName)\",\"\(ParseClient.ClassesPostParameters.mapString)\": \"\(mapString)\", \"\(ParseClient.ClassesPostParameters.mediaURL)\": \"\(mediaURL)\",\"\(ParseClient.ClassesPostParameters.latitude)\": \(latitude), \"\(ParseClient.ClassesPostParameters.longitude)\": \(longitude)}"
        
        
        _ = taskForPutMethod(addParamToMethod(value: objectId, method: ParseClient.ClassesMethods.LocationsUserUpdate, key: ParseClient.URLKeys.objectId), parameters: parameters, jsonBody: jsonBody) { result, error in
            if error == nil {
                
                
                completionHandler(true, nil)

                
            } else {
                completionHandler(false, error)
            }
            
        }
        
        
    }
    
    func getStudentInfo(uniqueKey: String, storeResult: @escaping (_ result: AnyObject?) -> Bool, completionHandler: @escaping (Bool, NSError?) -> Void) {
        
        
        let url = ParseClient.Constants.UserData
        let parameters:[String:AnyObject] = [String:AnyObject]()
        _ = taskForGetUserInfoMethod(addParamToMethod(value: uniqueKey, method: url, key: ParseClient.URLKeys.objectId), parameters: parameters, jsonBody: "") { result, error in
            
            if error == nil {
                
                
                completionHandler(storeResult(result), nil)

                
            } else {
                completionHandler(false, error)
            }

            
        }
        
        
    }
    
    

    func deleteSession(completionHandler: @escaping (Bool, NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()

        _ = taskForDeleteAuthMethod(ParseClient.Constants.Auth_URL, parameters: parameters as [String : AnyObject]) { result, error in
            if error == nil {
                
                completionHandler(true, nil)
                
            } else {
                completionHandler(false, error)
            }
            
        }
        
        
    }
    
    
    private func addParamToMethod(value: String, method: String, key: String) -> String {
        var url = method
        let range = url.range(of: "{\(key)}")
        url.replaceSubrange(range!, with: value)
        return url
    }
    
}
