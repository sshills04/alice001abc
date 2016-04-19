//
//  Publisher.swift
//  Food2Fork
//
//  Created by Victor Benning on 4/17/16.
//  Copyright © 2016 Benning. All rights reserved.
//

import Foundation

class Publisher: NSObject {
    
    var name:String!
    var url:String!
    
    override init() {
        self.name = String()
        self.url = String()
        
        super.init()
    }
    
    
    
    func buildPublisher(data:AnyObject) throws-> Publisher{
        
        
        let pub = Publisher()
        
        if let name = (data["publisher"] as? String){
            pub.name = name
        }else{
            throw CustomError(msg: "Error serializing publisher name")
        }
        
        if let url = (data["publisher_url"] as? String){
            pub.url = url
        }else{
            throw CustomError(msg: "Error serializing publisher url")
        }
        
        return pub
        
        
    }
}
