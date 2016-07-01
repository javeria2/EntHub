//
//  File.swift
//  entHub
//
//  Created by Sanchay  Javeria on 7/1/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import Foundation

class Posts {
    
    private var postDescription: String!
    private var postingUsername: String!
    private var likes: Int!
    private var image: String?
    private var uid: String!
    
    var Description: String {
        return postDescription
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

}