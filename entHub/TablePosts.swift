//
//  TablePosts.swift
//  entHub
//
//  Created by Sanchay  Javeria on 6/30/16.
//  Copyright © 2016 SanchayJaveria. All rights reserved.
//

import UIKit
import Firebase

class TablePosts: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    var posts = [Posts]()
    static var cacheImages = NSCache()
    
    override func viewDidLoad() {
        table.delegate = self
        table.dataSource = self
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
        return posts.count
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let fetchUrl = posts[indexPath.row].Image {
            return 352
        } else {
            return 100
        }
    }
}
