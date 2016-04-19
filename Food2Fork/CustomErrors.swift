//
//  CustomErrors.swift
//  Food2Fork
//
//  Created by Victor Benning on 4/17/16.
//  Copyright © 2016 Benning. All rights reserved.
//

import Foundation

class CustomError : ErrorType{
    var msg:String!
    
    init(msg:String){
        self.msg = msg
    }
    
    init(){
        
    }
    
}