//
//  PictureViewController.swift
//  Tumblr
//
//  Created by Yawen & Szu Kai Yang on 2/2/2017.
//  Copyright © 2017 YangSzu Kai. All rights reserved.
//

import UIKit
import AFNetworking

class PictureViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var TableView: UITableView!
    
    var loadingMoreView:InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var posts: [NSDictionary?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_refreshControl:)), for: UIControlEvents.valueChanged)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: TableView.contentSize.height, width: TableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        TableView.addSubview(loadingMoreView!)
        
        var insets = TableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        TableView.contentInset = insets
        
        TableView.delegate = self
        TableView.dataSource = self
        
        //Add refresh control to table view
        TableView.insertSubview(refreshControl, at: 0)
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    
    }
    
    func loadData(){
        
        //Update from the last load data
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(self.posts.count)")
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
                   
                    //Set flag to false
                    self.isMoreDataLoading = false
                    
                    //Stop loading indicator
                    self.loadingMoreView!.stopAnimating()
                    
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts += responseFieldDictionary["posts"] as! [NSDictionary?]
                        
                        self.TableView.reloadData()
                        
                    }
                }
        });
        
        task.resume()

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! Cell_ContollerTableViewCell
        
        let post = posts[indexPath.row]
        
        if let title_blog = post?.value(forKeyPath: "blog_name") as? String{
            cell.PicTitle.text = title_blog
        }
        
        
        if let photos = post?.value(forKeyPath: "photos") as? [NSDictionary]
        {
            let imageURLstring = photos[0].value(forKeyPath: "original_size.url") as? String
            
            let username = post?.value(forKeyPath: "blog_name") as! String
            if let avartarURL = URL(string: "https://api.tumblr.com/v2/blog/\(username).tumblr.com/avatar/512"){
                cell.Avartar.setImageWith(avartarURL)
                cell.Avartar.layer.cornerRadius = 30
                cell.Avartar.clipsToBounds = true
            }
            
            if let imageURL = URL(string: imageURLstring!){
            cell.Pictures_View.setImageWith(imageURL)
            
            }
        }
        
        return cell
    }
    
    private func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        
        let PhotoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! Cell_ContollerTableViewCell
        
        // Configure YourCustomCell using the outlets that you've defined.
        
        return PhotoCell
    }

    /*
     Infinity Scroll. 
     When user reach to the end of the data it loads more.
    */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading){
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = TableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - TableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if (scrollView.contentOffset.y > scrollOffsetThreshold && TableView.isDragging){
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: TableView.contentSize.height, width: TableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadData()
            }
        }
    }
    
    func refreshControlAction(_refreshControl: UIRefreshControl){
        
        //Update from the last load data
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV&offset=\(self.posts.count)")
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
                        self.posts += responseFieldDictionary["posts"] as! [NSDictionary?]
                        
                        //Reload tableview
                        self.TableView.reloadData()
                        
                        //Tell refreshControl to stop spinning
                        _refreshControl.endRefreshing()
                    }
                }
         });
        task.resume()

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination as! PhotoDetailsViewController
        let cell = sender as! Cell_ContollerTableViewCell
        
        //Copy the pressed picture to the other viewController
        destinationViewController.image = cell.Pictures_View.image
    }
}
