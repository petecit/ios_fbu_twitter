//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-10-05.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    // MARK: Properties
    var id: Int64? // For favoriting, retweeting & replying
    var text: String? // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int? // Update favorite count label
    var retweeted: Bool? // Configure retweet button
    var user: User? // Contains name, screenname, etc. of tweet author
    var createdAtString: String? // Display date
    
    init(dictionary: [String : Any]) {
        super.init()
        
        if let twitid: NSNumber = dictionary["id"] as? NSNumber{
            id = twitid.int64Value
            
        }
        text = dictionary["text"] as? String
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as? Int
        //print("retweet count \(retweetCount)")
        retweeted = dictionary["retweeted"] as? Bool
        
        let user = dictionary["user"] as! [String: Any]
        
        //let g = user["screen_name"]
        //print("screen name \(g.debugDescription)")
        self.user = User(dictionary: user)
        
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        // Convert Date to String
        createdAtString = formatter.string(from: date)
        // print("created at \(createdAtString)")
    }
}
