//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//
import Foundation

class ParseClient: NSObject {
    
    var userModel = UserModel.sharedInstance()
    var session = URLSession.shared
    
    
    var fbToken: String? = nil


    
    
    func taskForPostAuthenticationMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: method)!)
        request.httpMethod = Constants.POST
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
        
            func sendError(_ error: String, code: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", code: 2)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 1)
                return
            }
        
            self.convertDataWithCompletionHandler(self.reformatResponseData(data: data), completionHandlerForConvertData: completionHandlerForPOST)
        
        }
        
        task.resume()
        return task
        
        
    }
    
    
    func taskForGetMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: formURLWithParams(parameters: parameters, method: method)!)
        request.httpMethod = Constants.GET
        request.addValue(Constants.API_KEY, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String, code: Int) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", code: 2)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 1)
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)

        }
        
        task.resume()
        return task
        
        
    }
    
    func taskForGetUserInfoMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: URL(string: method)!)
        request.httpMethod = Constants.GET
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String, code: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGetMethod", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", code: 2)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 1)
                return
            }
            
            self.convertDataWithCompletionHandler(self.reformatResponseData(data: data), completionHandlerForConvertData: completionHandlerForGET)
            
        }
        
        task.resume()
        return task
        
        
    }
    
    func taskForPostMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: formURLWithParams(parameters: parameters, method: method)!)
        request.httpMethod = Constants.POST
        request.addValue(Constants.API_KEY, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String, code: Int) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", code: 2)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 1)
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            
            
            
        }
        
        task.resume()
        return task
        
        
    }
    
    
    func taskForPutMethod(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: formURLWithParams(parameters: parameters, method: method)!)
        request.httpMethod = Constants.PUT
        request.addValue(Constants.API_KEY, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String, code: Int) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethod", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", code: 2)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 1)
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)

            
            
            
            
        }
        
        task.resume()
        return task
        
        
    }
    
    func taskForDeleteAuthMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
     
        
        
        let request = NSMutableURLRequest(url: URL(string: method)!)
        request.httpMethod = Constants.DELETE
        
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            
            func sendError(_ error: String, code: Int) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethod", code: code, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)", code: 1)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!", code: 2)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!", code: 1)
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)

            
            
        }
        
        task.resume()
        return task
        
        
    }
    
    
    private func reformatResponseData(data: Data) -> Data {
        let range = Range(uncheckedBounds: (5, data.count))
        let newData = data.subdata(in: range)
        return newData
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    private func formURLWithParams(parameters: [String:AnyObject], method: String? = nil) -> URL? {
        
        var url = URLComponents()
        url.scheme = Constants.Api_Scheme
        url.host = Constants.Api_Host
        url.path = Constants.Api_Path + (method ?? "")
        url.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            
            url.queryItems!.append(URLQueryItem(name: key, value: "\(value)"))
            
        }
        
        return url.url
    }
    
   /* struct Singleton {
        static var sharedInstance = ParseClient()
    }*/
    static let sharedInst = ParseClient()
    
    class func sharedInstance() -> ParseClient {
        return sharedInst
    }

    
   
    
    
    
}
