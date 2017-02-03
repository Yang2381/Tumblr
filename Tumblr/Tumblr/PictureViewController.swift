//
//  PictureViewController.swift
//  Tumblr
//
//  Created by Yawen on 2/2/2017.
//  Copyright © 2017 YangSzu Kai. All rights reserved.
//

import UIKit
import AFNetworking

class PictureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    @IBOutlet weak var TableView: UITableView!
    
    
    var posts: [NSDictionary]?
    override func viewDidLoad() {
        super.viewDidLoad()

        TableView.delegate = self
        TableView.dataSource = self
        
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as? [NSDictionary]
                        self.TableView.reloadData()
                        
                    }
                }
        });
        
        task.resume()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let posts = posts {
            return posts.count
        }else {
            return 0
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! Cell_ContollerTableViewCell
        
        let post = posts?[indexPath.row]
        if let photos = post?.value(forKeyPath: "photos") as? [NSDictionary]
        {
            let imageURLstring = photos[0].value(forKeyPath: "original_size.url") as? String
            if let imageURL = URL(string: imageURLstring!){
            cell.Pictures_View.setImageWith(imageURL)
            }else{
            }
        }else{
            
        }
        
        return cell
    }
    
    private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let PhotoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! Cell_ContollerTableViewCell
        
        // Configure YourCustomCell using the outlets that you've defined.
        
        return PhotoCell
    }

}
