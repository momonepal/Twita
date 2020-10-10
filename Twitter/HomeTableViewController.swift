//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Mohit on 10/10/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var noOfTweet : Int = 0
    
    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
           loadTweet()
       }
    
    func loadTweet(){
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParam = ["count":20]
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParam, success: { (tweets:[NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
                
            }
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("error getting tweet")
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text =  user["name"] as? String
        cell.tweetLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageURL = URL(string: (user["profile_image_url_https"]) as! String)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imagedata = data{
            cell.profileImage.image = UIImage(data: imagedata)
        }
        
        return cell
    }
    
   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    
}
