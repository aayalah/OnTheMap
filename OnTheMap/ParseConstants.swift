//
//  ParseClientConstants.swift
//  OnTheMap
//
//  Created by Alejandro Ayala-Hurtado on 12/11/16.
//  Copyright © 2016 MobileApps. All rights reserved.
//

extension ParseClient {
    
    
    struct Constants {
        
        static let API_KEY = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let REST_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let FACEBOOK_APP_ID = "365362206864879"
        static let FACEBOOK_URL_SUFFIX = "onthemap"
        static let POST = "POST"
        static let GET = "GET"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
        
        ///URLs
        static let Api_Scheme = "https"
        static let Api_Host = "parse.udacity.com"
        static let Api_Path = "/parse/classes"
        static let Auth_URL = "https://www.udacity.com/api/session"
        
        
    }

    // Methods
    struct ClassesMethods {
        static let Locations = "/StudentLocation"
        static let LocationsUserUpdate = "/StudentLocation/{id}"
        static let UserData = "/users/{id}"
    }
    
    //URL Keys
    
    struct URLKeys {
        let objectId = "id"
    }
    
    //Parameters
    struct Parameters {
        static let sessionId = "session_id"
    }
    
    struct ClassesGetParameters {
        
        static let limit = "limit"
        static let skip = "skip"
        static let where_param = "where"
        static let uniqueKey = "uniqueKey"
    }
    
    struct ClassesPostParameters {
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"

    }
    
    struct AuthenticationPostParameters {
        static let username = "username"
        static let bodyKey = "udacity"
        static let password = "password"
        
    }
    
    struct FBAuthenticationPostParameters {
        static let bodyKey = "facebook_mobile"
        static let accessToken = "access_token"
    }
    
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authentication
        static let Session = "session"
        static let SessionID = "id"
        static let account = "account"
        static let key = "key"
        
        
        // MARK: StudentLocations
        static let locBodyKey = "results"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"

        
    }
    
    
    
}
