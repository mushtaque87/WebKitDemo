//
//  UserData.swift
//  WebKitDemo
//
//  Created by Mushtaque Ahmed on 10/15/19.
//  Copyright © 2019 Mushtaque Ahmed. All rights reserved.
//

import Foundation


class UserData {
    var username : String = ""
    var email : String = ""
    var lastname : String = ""
    
    
    init(_ username:String , _ email:String , _ lastname : String) {
        self.username = username
        self.email = email
        self.lastname = lastname
    }
}
