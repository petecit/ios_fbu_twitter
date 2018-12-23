//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-08-11.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, ComposeViewControllerDelegate {
    func did(post: Tweet) {
        updateUserInformation()
        completeNetworkRequest()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet] = []
    var refreshControl: UIRefreshControl!
    var viewDidAppear: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update user
        self.updateUserInformation()
        
        // tableView data source
        tableView.dataSource = self
        //tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        //tableView.rowHeight = 280
        
        // pull-to-refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TimelineViewController.completeNetworkRequest), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // network request
        self.completeNetworkRequest()
        
        // Do any additional setup after loading the view.
        viewDidAppear = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewDidAppear {
            self.completeNetworkRequest()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Update User
    func updateUserInformation() {
        APIManager.shared.getCurrentAccount { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let user = user {
                User.current = user
            }
        }
    }
    
    // Network Request
    func completeNetworkRequest() {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.tweets = tweets!
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    
    @IBAction func onTapCompose(_ sender: Any) {
        self.performSegue(withIdentifier: "ComposeSegue", sender: nil)
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.user = tweet.user // User.current
        cell.indexPath = indexPath
        cell.updateAllContent()
        cell.parentView = self as TimelineViewController
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.updateUserInformation()
        
        if (segue.identifier == "ComposeSegue") {
            if let composeView = segue.destination as? ComposeViewController {
                composeView.delegate = self
                composeView.user = User.current
            }
        }
        
        if (segue.identifier == "DetailSegue") {
            if let detailView = segue.destination as? DetailViewController {
                if let cell = sender as! TweetCell? {
                    detailView.tweet = tweets[(cell.indexPath?.row)!]
                }
                detailView.user = User.current
            }
        }
        
        if (segue.identifier == "ProfileSegue") {
            if let profileView = segue.destination as? ProfileViewController {
                profileView.user = User.current
            }
            
        }
        
    }
}
