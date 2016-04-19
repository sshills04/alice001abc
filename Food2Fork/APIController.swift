//
//  APIController.swift
//  Food2Fork
//
//  Created by Victor Benning on 4/17/16.
//  Copyright © 2016 Benning. All rights reserved.
//

import Foundation


class APIController: NSObject {
    
    func HTTPGetJSON(url: String,callback: (NSDictionary) throws -> Void) throws {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            do {
                if(error != nil){
                    throw CustomError(msg: String(error))
                }
                let result = try NSJSONSerialization.JSONObjectWithData(data!, options: [NSJSONReadingOptions.AllowFragments])
                    as! NSDictionary
                try callback(result)
            } catch {
                print("Error")
            }
        }
        
        task.resume()
    }
}
