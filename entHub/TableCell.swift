//
//  TableCell.swift
//  entHub
//
//  Created by Sanchay  Javeria on 6/30/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class TableCell: UITableViewCell {
    
    var Post: Posts!
    var req: Request?
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var dp: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    var fetchLikes: FIRDatabaseReference!
    @IBOutlet weak var likeUnlike: UIImageView!
    var recognizer: UITapGestureRecognizer!
    
    override func awakeFromNib() {
        recognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        recognizer.numberOfTapsRequired = 1
        likeUnlike.addGestureRecognizer(recognizer)
        likeUnlike.userInteractionEnabled = true
        
        fetchLikes = FIRDatabaseReference()
        super.awakeFromNib()
    }
    
    func tapped(recognizer: UITapGestureRecognizer) {
        fetchLikes.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let returnedNull = snapshot.value as? NSNull {
                self.likeUnlike.image = UIImage(named: "liked")
                self.Post.likeArithmetic(true)
                self.fetchLikes.setValue(true)
                print(1)
            } else {
                self.likeUnlike.image = UIImage(named: "notliked")
                self.Post.likeArithmetic(false)
                self.fetchLikes.removeValue()
                print(2)
            }
        })
    }
    
    override func drawRect(rect: CGRect) {
        dp.layer.cornerRadius = dp.frame.size.width / 2
        dp.clipsToBounds = true
        mainImage.clipsToBounds = true
    }
    
    func configureCell(fetchPost: Posts, image: UIImage?) {
        Post = fetchPost
        fetchLikes = networkPacket.service.currentUser.child("likes").child(fetchPost.Id)
        if fetchPost.Image == nil {
            mainImage.hidden = true
        } else {
            if image == nil {
                req = Alamofire.request(.GET, fetchPost.Image!).validate(contentType: ["image/*"]).response(completionHandler: { (request, response, data, error) in
                    if error != nil {
                        print(error.debugDescription)
                    } else {
                        let fetchImg = UIImage(data: data!)!
                        self.mainImage.image = fetchImg
                        TablePosts.cacheImages.setObject(fetchImg, forKey: fetchPost.Image!)
                    }
                })
            } else {
                mainImage.image = image
            }
        }
        
        fetchLikes.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let returnedNull = snapshot.value as? NSNull {
                self.likeUnlike.image = UIImage(named: "notliked")
                print(3)
            } else {
                self.likeUnlike.image = UIImage(named: "liked")
                print(4)
            }
        })
        
        postText.text = fetchPost.Description
        likes.text = "\(fetchPost.likeNo) likes"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
