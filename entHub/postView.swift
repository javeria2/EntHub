//
//  File.swift
//  entHub
//
//  Created by Sanchay  Javeria on 7/1/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import Foundation
import Firebase

class Posts {
    
    private var postReference: FIRDatabaseReference!
    private var postDescription: String!
    private var postingUsername: String!
    private var likes: Int!
    private var image: String?
    private var uid: String!
    
    
    var Description: String {
        if postDescription == nil {
            postDescription = ""
        }
        return postDescription
    }
   
    var post: FIRDatabaseReference {
        return postReference
    }
    
    var username: String {
        return postingUsername
    }
    var likeNo: Int {
        return likes
    }
    var Image: String? {
        return image
    }
    var Id: String {
        return uid
    }
    
    init(Description: String, img: String?, name: String) {
        postDescription = Description
        image = img
        postingUsername = name
    }
    
    init(uid: String, dict: Dictionary<String, AnyObject>) {
        self.uid = uid
        self.postReference = networkPacket.service.post.child(key)
        if let likes = dict["likes"] as? Int {
            self.likes = likes
        }
        if let image = dict["imageUrl"] as? String {
            self.image = image
        }
        if let Description = dict["description"] as? String {
            postDescription = Description
        }
    }
    
    func likeArithmetic(flag: Bool) {
        if flag {
            likes = likes + 1
        } else {
            likes = likes - 1
        }
        postReference.child("likes").setValue(likes)
    }

}