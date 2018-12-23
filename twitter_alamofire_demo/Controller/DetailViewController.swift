//
//  DetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by peter on 12/22/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var faveCount: UIButton!
    @IBOutlet weak var tweetCount: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var user: User?
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.user = self.tweet!.user
        updateUserInformation()
    }
    
    func updateUserInformation() {
        if let tweet = self.tweet, let user = self.user  {
            if let propicURL = user.profilepic {
                profilePicture.af_setImage(withURL: propicURL)
            }
            timeStampLabel.text = tweet.createdAtString
            realNameLabel.text = user.name
            usernameLabel.text = "@\(user.screenName!)"
            tweetTextLabel.text = tweet.text
            faveCount.setTitle("\(tweet.favoriteCount!)", for: UIControlState.normal)
            tweetCount.setTitle("\(tweet.retweetCount!)", for: UIControlState.normal)
            updateFavoriteTweetIcons(tweet)
            updateFavoriteTweetCounts(tweet)
        }
    }
    
    func updateFavoriteTweetIcons(_ tweet: Tweet) {
        if (tweet.favorited! == true) {
            self.favoriteButton.setImage(UIImage(named: "favor-icon-red.png"), for: .normal)
        }
        else {
            self.favoriteButton.setImage(UIImage(named: "favor-icon.png"), for: .normal)
        }
        if (tweet.retweeted == true) {
            self.retweetButton.setImage(UIImage(named: "retweet-icon-green.png"), for: .normal)
        }
        else {
            self.retweetButton.setImage(UIImage(named: "retweet-icon.png"), for: .normal)
        }
    }
    
    func updateFavoriteTweetCounts(_ tweet: Tweet) {
        favoriteButton.setTitle("\(tweet.favoriteCount!)", for: .normal)
        retweetButton.setTitle("\(tweet.retweetCount!)", for: .normal)
    }
    
    @IBAction func onTapFavorite(_ sender: Any) {
        if (tweet!.favorited == false) {
            APIManager.shared.favorite(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error Favoriting Tweet: \(error.localizedDescription)")
                } else {
                    self.tweet!.favorited = true
                    self.tweet!.favoriteCount! += 1
                    self.updateFavoriteTweetCounts(self.tweet!)
                    self.updateFavoriteTweetIcons(self.tweet!)
                }
            }
        }
        else {
            APIManager.shared.unfavorite(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error Favoriting Tweet: \(error.localizedDescription)")
                } else {
                    self.tweet!.favorited = false
                    self.tweet!.favoriteCount! -= 1
                    self.updateFavoriteTweetCounts(self.tweet!)
                    self.updateFavoriteTweetIcons(self.tweet!)
                }
            }
        }
    }
    
    
    @IBAction func onTapRetweet(_ sender: Any) {
        if (tweet!.retweeted == false) {
            APIManager.shared.retweet(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error Favoriting Tweet: \(error.localizedDescription)")
                } else {
                    self.tweet!.retweeted = true
                    self.tweet!.retweetCount! += 1
                    self.updateFavoriteTweetCounts(self.tweet!)
                    self.updateFavoriteTweetIcons(self.tweet!)
                }
            }
        }
        else {
            APIManager.shared.unretweet(self.tweet!) { (post, error) in
                if let  error = error {
                    print("Error Favoriting Tweet: \(error.localizedDescription)")
                } else {
                    self.tweet!.retweeted = false
                    self.tweet!.retweetCount! -= 1
                    self.updateFavoriteTweetCounts(self.tweet!)
                    self.updateFavoriteTweetIcons(self.tweet!)
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ReplySegue") {
            if let composeView = segue.destination as? ComposeViewController {
                composeView.user = User.current
                composeView.isReply = true
                composeView.replyName = user?.screenName
            }
        }
    }
    
    @IBAction func onTapReply(_ sender: Any) {
        self.performSegue(withIdentifier: "ReplySegue", sender: nil)
    }
    

}
