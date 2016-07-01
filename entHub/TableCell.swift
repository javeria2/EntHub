//
//  TableCell.swift
//  entHub
//
//  Created by Sanchay  Javeria on 6/30/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import UIKit
import Alamofire

class TableCell: UITableViewCell {
    
    var req: Request?
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var dp: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func drawRect(rect: CGRect) {
        dp.layer.cornerRadius = dp.frame.size.width / 2
        dp.clipsToBounds = true
        mainImage.clipsToBounds = true
    }
    
    func configureCell(fetchPost: Posts, image: UIImage?) {
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
                        
                    }
                })
            } else {
                mainImage.image = image
            }
        }
        postText.text = fetchPost.Description
        likes.text = "\(fetchPost.likeNo) likes"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
