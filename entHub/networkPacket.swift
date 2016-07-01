//
//  networkPacket.swift
//  entHub
//
//  Created by Sanchay  Javeria on 6/30/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase



class networkPacket {
    static let service = networkPacket() //only one instance in memory
    
    private var baseUrl = url
    private var postUrl = url.child("posts")
    private var userUrl = url.child("users")
    
    var base: FIRDatabaseReference {
        return baseUrl
    }
    
    var post: FIRDatabaseReference {
        return postUrl
    }
    
    var user: FIRDatabaseReference {
        return userUrl
    }
    
    var currentUser: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(key) as! String //insert KEY_UID here
        let user = url.child("users").child(uid)
        return user
    }
    
    func newUser(uid: String, users: Dictionary<String, String>) {
        user.child(uid).updateChildValues(users) //or setValue(users)
    }
    
}