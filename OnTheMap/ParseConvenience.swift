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
                let sessionObject = result[ParseClient.JSONResponseKeys.Session] as! [String: AnyObject]
                self.sessionId = sessionObject[ParseClient.JSONResponseKeys.SessionID] as? String
                completionHandlerForAuth(true,nil)
            } else {
                completionHandlerForAuth(false, error!)
            }
  
        }
        
        
        
    }
    
    
    func getStudentsLocations(limit: Int, skip: Int, storeResult: @escaping (_ result: AnyObject?) -> Bool, completionHandler: @escaping (Bool, NSError?) -> Void) {
       // var parameters = [ParseClient.Parameters.sessionId: self.sessionId]
        var parameters = [ParseClient.ClassesGetParameters.limit : "\(limit)"]
        parameters[ParseClient.ClassesGetParameters.skip] = "\(skip)"
        _ = taskForGetMethod(ParseClient.ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: "") { result, error in
            if error == nil {
               
                if storeResult(result) {
                    completionHandler(true, nil)
                }
                completionHandler(false, nil)
                
                
            } else {
                completionHandler(false, error!)
            }
            
        }
        
    }
    
    
    func getStudentLocation(uniqueKey: Int, storeResult: @escaping (_ result: AnyObject?) -> Void, completionHandler: @escaping (Bool, NSError?) -> Void) {
        var parameters = [ParseClient.Parameters.sessionId: ParseClient.sharedInstance().sessionId]
        parameters[ParseClient.ClassesGetParameters.where_param] = "{\"\(ParseClient.ClassesGetParameters.uniqueKey)\":\"\(uniqueKey)\"}"
        
        _ = taskForGetMethod(ParseClient.ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: "") { result, error in
            if error == nil {
                let result = result as! [String: AnyObject]
                
                
                completionHandler(true, nil)
                
            } else {
                completionHandler(false, error)
            }
            
        }

        
    }
    
    func postStudentLocation(uniqueKey: Int, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completionHandler: @escaping (Bool, NSError?) -> Void) {
        
        var parameters = [ParseClient.Parameters.sessionId: ParseClient.sharedInstance().sessionId]
        let jsonBody = "{\"\(ParseClient.ClassesPostParameters.uniqueKey)\": \"\(uniqueKey)\", \"\(ParseClient.ClassesPostParameters.firstName)\": \"\(firstName)\", \"\(ParseClient.ClassesPostParameters.lastName)\": \"\(lastName)\",\"\(ParseClient.ClassesPostParameters.mapString)\": \"\(mapString)\", \"\(ParseClient.ClassesPostParameters.mediaURL)\": \"\(mediaURL)\",\"\(ParseClient.ClassesPostParameters.latitude)\": \(latitude), \"\(ParseClient.ClassesPostParameters.longitude)\": \(longitude)}"

        _ = taskForPostMethod(ParseClient.ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: jsonBody) { result, error in
            if error == nil {
                let result = result as! [String: AnyObject]
                
                
                completionHandler(true, nil)
                
            } else {
                completionHandler(false, error)
            }
            
        }
        

    }
    
    //need to fix
    func putStudentLocation(uniqueKey: Int, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completionHandler: @escaping (Bool, NSError?) -> Void) {
        
        var parameters = [ParseClient.Parameters.sessionId: ParseClient.sharedInstance().sessionId]
        let jsonBody = "{\"\(ParseClient.ClassesPostParameters.uniqueKey)\": \"\(uniqueKey)\", \"\(ParseClient.ClassesPostParameters.firstName)\": \"\(firstName)\", \"\(ParseClient.ClassesPostParameters.lastName)\": \"\(lastName)\",\"\(ParseClient.ClassesPostParameters.mapString)\": \"\(mapString)\", \"\(ParseClient.ClassesPostParameters.mediaURL)\": \"\(mediaURL)\",\"\(ParseClient.ClassesPostParameters.latitude)\": \(latitude), \"\(ParseClient.ClassesPostParameters.longitude)\": \(longitude)}"
        
        _ = taskForPutMethod(ParseClient.ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: jsonBody) { result, error in
            if error == nil {
                let result = result as! [String: AnyObject]
                
                
                completionHandler(true, nil)
                
            } else {
                completionHandler(false, error)
            }
            
        }
        
        
    }
    
    
    

    func deleteSession(uniqueKey: Int, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completionHandler: @escaping (Bool, NSError?) -> Void) {
        
        var parameters = [String:AnyObject]()

        _ = taskForDeleteAuthMethod(ParseClient.Constants.Auth_URL, parameters: parameters as [String : AnyObject]) { result, error in
            if error == nil {
                
                completionHandler(true, nil)
                
            } else {
                completionHandler(false, error)
            }
            
        }
        
        
    }
    
    
    
}
