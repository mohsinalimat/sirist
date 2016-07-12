//
//  APIManager.swift
//  Sirist
//
//  Created by Rob Reinhardt on 7/8/16.
//  Copyright © 2016 RR. All rights reserved.
//

import Foundation

class APIManager : NSObject {
    
    // MARK: - Init
    
    static let sharedInstance = APIManager()
    private override init() {}
    
    // MARK: - Properties
    
    private let clientID = "ed98f948a0104c7eab9c13f9d457ed8f"
    private let clientSecret = "84384fb0319343eebfc9469f0d1adf08"
    private let scope = "task:add"
    private let authURL = "https://todoist.com/oauth/authorize"
    
    // MARK: - Initial Authorization Requests
    
    func generateAuthRequest() -> NSMutableURLRequest {
        let querystring = "?client_id=\(clientID)&scope=\(scope)&state=testunguessablestring"
        let url = NSURL(string: authURL + querystring)
        let request = NSMutableURLRequest(URL: url!)
        
        return request
    }
    
    // MARK: - Token Exchange
    
    func makeAuthTokenExchange(code: String) {
                
        let request = NSMutableURLRequest(URL: NSURL(string: "https://todoist.com/oauth/access_token")!)
            request.HTTPMethod = "POST"
        
        let postString = "client_id=\(clientID)&client_secret=\(clientSecret)&code=\(code)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                print("Code: \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let token = (json["access_token"]) as? String {
                    self.saveToken(token)
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            
        }
        task.resume()
    }
    
    // MARK: - Token Storage
    
    func saveToken(token: String) -> Bool {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
        NSNotificationCenter.defaultCenter().postNotificationName("savedtoken", object: nil)
        return true
    }

    func hasToken() -> Bool {
        if (NSUserDefaults.standardUserDefaults().objectForKey("token") as? String) != nil {
            return true
        }
        
        return false
    }
    
    func getToken() -> String? {
        if let token = (NSUserDefaults.standardUserDefaults().objectForKey("token") as? String) {
            return token
        }
        return nil
    }
    
}