//
//  TablePosts.swift
//  entHub
//
//  Created by Sanchay  Javeria on 6/30/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class TablePosts: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var cameraRoll: shadowImageView!
    @IBOutlet weak var textField: shadowTextView!
    @IBOutlet weak var table: UITableView!
    var posts = [Posts]()
    var camFlag = false
    static var cacheImages = NSCache()
    var pickImage = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        table.delegate = self
        table.dataSource = self
        pickImage.delegate = self
        super.viewDidLoad()
        
        table.estimatedRowHeight = 352
        
        // Do any additional setup after loading the view.
        networkPacket.service.post.observeEventType(.Value, withBlock: { (dataSnapshot) in
            /* closures are called regardless of their location, wether in viewDidLoad or not */
            
            self.posts = []
            /* parse each post */
            if let entry = dataSnapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for eachEntry in entry {
                    if let posts = eachEntry.value as? Dictionary<String, AnyObject> {
                        let id = eachEntry.key
                        let createPost = Posts(uid: id, dict: posts)
                        self.posts.append(createPost)
                    }
                }
            }
            
            self.table.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count - 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let fetchPost = posts[indexPath.row]
        var image: UIImage!
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? TableCell {
            if let url = fetchPost.Image {
                image = TablePosts.cacheImages.objectForKey(url) as? UIImage
            }
            cell.configureCell(fetchPost, image: image)
            return cell
        }
        return UITableViewCell()
    }
    
    func postImage(url: String?) {
        
        var post: Dictionary<String, AnyObject> = ["description": textField.text!, "likes":0]
        if url != nil {
            post["imageUrl"] = url!
        }
        let childId = networkPacket.service.post.childByAutoId()
        childId.setValue(post)
        textField.text = ""
        cameraRoll.image = UIImage(named: "camera-icon")
        table.reloadData()
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        table.alpha = 1.0
    }
    
    @IBAction func post(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = CGPointMake(self.table.bounds.width / 2, self.table.bounds.height / 2)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
        table.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        table.alpha = 0.5
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        if textField.text == "" {
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            return
        } else {
            if let image = cameraRoll.image {
                
                if camFlag {
                    /* see imageShack API documentation */
                    let imgUrl = NSURL(string: "https://post.imageshack.us/upload_api.php")!
                    let compressed = UIImageJPEGRepresentation(image, 0.3)!
                    let APIKey = "16GHJNOR2a1a29be9cc5ddaf93ba83e2678825d2"
                    let encodingData = APIKey.dataUsingEncoding(NSUTF8StringEncoding)!
                    let keyName = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                    /* imageShack requirements end */
                    
                    Alamofire.upload(.POST, imgUrl, multipartFormData: { (MultipartFormData) in
                       
                        MultipartFormData.appendBodyPart(data: compressed, name: "fileupload", fileName: "image", mimeType: "image/jpeg")
                        MultipartFormData.appendBodyPart(data: encodingData, name: "key")
                        MultipartFormData.appendBodyPart(data: keyName, name: "format")
                        }, encodingCompletion: { (result) in
                            
                            switch result {
                            case .Success(let upload, _, _):
                             
                                upload.responseJSON(completionHandler: { (response) in
                                  
                                    if let returnedJSON = response.result.value as? Dictionary<String, AnyObject> {
                                        if let returnedURL = returnedJSON["links"] as? Dictionary<String, AnyObject> {
                                            if let imageURL = returnedURL["image_link"] as? String{
                                                self.postImage(imageURL)
                                            }
                                        }
                                    }
                                })
                            case .Failure(let error):
                                print(error)
                            }
                    })
                } else {
                    postImage(nil)
                }
            }
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if posts[indexPath.row].Image != nil {
            return 352
        } else {
            return 100
        }
    }
    
    @IBAction func selectImageFromCameraRoll(sender: UITapGestureRecognizer) {
        presentViewController(pickImage, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        pickImage.dismissViewControllerAnimated(true, completion: nil)
        cameraRoll.image = image
        camFlag = true
    }
    
   
}
