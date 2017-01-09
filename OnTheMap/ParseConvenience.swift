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
        let jsonBody = "{\"\(AuthenticationPostParameters.bodyKey)\": {\"\(AuthenticationPostParameters.username)\": \"\(userName)\",\"\(AuthenticationPostParameters.password)\": \"\(passWord)\"}}"
        _ = taskForPostAuthenticationMethod(Constants.Auth_URL, parameters: parameters, jsonBody: jsonBody) { result, error in
            if error == nil {
                let result = result as! [String: AnyObject]
                let accountObject = result[JSONResponseKeys.account] as! [String: AnyObject]
                self.userModel.getCurrentUser().setKey(val: (accountObject[JSONResponseKeys.key] as? String)!)
                completionHandlerForAuth(true,nil)
            } else {
                completionHandlerForAuth(false, error!)
            }
  
        }
        
        
        
    }
    
    func authenticateViaFacebook(token: String, completionHandlerForAuth: @escaping (Bool, NSError?) -> Void) {
        
        let parameters = [String: AnyObject]();
        let jsonBody = "{\"\(FBAuthenticationPostParameters.bodyKey)\": {\"\(FBAuthenticationPostParameters.accessToken)\": \"\(token)\"}}"
        
        _ = taskForPostAuthenticationMethod(Constants.Auth_URL, parameters: parameters, jsonBody: jsonBody) { result, error in
            if error == nil {
                let result = result as! [String: AnyObject]
                let accountObject = result[JSONResponseKeys.account] as! [String: AnyObject]
                self.userModel.getCurrentUser().setKey(val: (accountObject[JSONResponseKeys.key] as? String)!)
                completionHandlerForAuth(true,nil)
            } else {
                completionHandlerForAuth(false, error!)
            }
            
        }
        
        
    }
    
    
    func getStudentsLocations(limit: Int, skip: Int, storeResult: @escaping (_ result: AnyObject?) -> Bool, completionHandler: @escaping (Bool, NSError?) -> Void) {
       
        var parameters = [ClassesGetParameters.limit : "\(limit)"]
        parameters[ClassesGetParameters.skip] = "\(skip)"
        parameters[ClassesGetParameters.recent] = "-\(ClassesGetParameters.updatedOrder)"
        _ = taskForGetMethod(ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: "") { result, error in
            if error == nil {
                
                completionHandler(storeResult(result), nil)
                
                
            } else {
                completionHandler(false, error!)
            }
            
        }
        
    }
    
    
    func getStudentLocation(uniqueKey: String, storeResult: @escaping (_ result: AnyObject?) -> Bool, completionHandler: @escaping (Bool, NSError?) -> Void) {
        var parameters:[String:AnyObject] = [String:AnyObject]()
        parameters[ClassesGetParameters.where_param] = "{\"\(ClassesGetParameters.uniqueKey)\":\"\(uniqueKey)\"}" as AnyObject?
        
        _ = taskForGetMethod(ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: "") { result, error in
            if error == nil {

                completionHandler(storeResult(result), nil)
                
            } else {
                completionHandler(false, error)
            }
            
        }

        
    }
    
    func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float, completionHandler: @escaping (Bool, NSError?) -> Void) {
        let parameters:[String:AnyObject] = [String:AnyObject]()
        let jsonBody = "{\"\(ClassesPostParameters.uniqueKey)\": \"\(uniqueKey)\", \"\(ClassesPostParameters.firstName)\": \"\(firstName)\", \"\(ClassesPostParameters.lastName)\": \"\(lastName)\",\"\(ClassesPostParameters.mapString)\": \"\(mapString)\", \"\(ClassesPostParameters.mediaURL)\": \"\(mediaURL)\",\"\(ClassesPostParameters.latitude)\": \(latitude), \"\(ClassesPostParameters.longitude)\": \(longitude)}"

        _ = taskForPostMethod(ClassesMethods.Locations, parameters: parameters as [String : AnyObject], jsonBody: jsonBody) { result, error in
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
        let jsonBody = "{\"\(ClassesPostParameters.uniqueKey)\": \"\(uniqueKey)\", \"\(ClassesPostParameters.firstName)\": \"\(firstName)\", \"\(ClassesPostParameters.lastName)\": \"\(lastName)\",\"\(ClassesPostParameters.mapString)\": \"\(mapString)\", \"\(ClassesPostParameters.mediaURL)\": \"\(mediaURL)\",\"\(ClassesPostParameters.latitude)\": \(latitude), \"\(ClassesPostParameters.longitude)\": \(longitude)}"
        
        
        _ = taskForPutMethod(addParamToMethod(value: objectId, method: ClassesMethods.LocationsUserUpdate, key: URLKeys.objectId), parameters: parameters, jsonBody: jsonBody) { result, error in
            if error == nil {
                
                
                completionHandler(true, nil)

                
            } else {
                completionHandler(false, error)
            }
            
        }
        
        
    }
    
    func getStudentInfo(uniqueKey: String, storeResult: @escaping (_ result: AnyObject?) -> Bool, completionHandler: @escaping (Bool, NSError?) -> Void) {
        
        
        let url = Constants.UserData
        let parameters:[String:AnyObject] = [String:AnyObject]()
        _ = taskForGetUserInfoMethod(addParamToMethod(value: uniqueKey, method: url, key: URLKeys.objectId), parameters: parameters, jsonBody: "") { result, error in
            
            if error == nil {
                
                
                completionHandler(storeResult(result), nil)

                
            } else {
                completionHandler(false, error)
            }

            
        }
        
        
    }
    
    

    func deleteSession(completionHandler: @escaping (Bool, NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()

        _ = taskForDeleteAuthMethod(Constants.Auth_URL, parameters: parameters as [String : AnyObject]) { result, error in
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
