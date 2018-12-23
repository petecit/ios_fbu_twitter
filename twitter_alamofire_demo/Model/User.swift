//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-10-05.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var dictionary: [String: Any]?
    
    var name: String?
    var screenName: String?
    var profilepic: URL?
    
    var bannerpic: URL?
    var friendcount: Int?
    var followercount : Int?
    var userid: Int64?
    var favoritecount: Int?
    var statusCount : Int?
    
    init(dictionary: [String : Any]) {
        super.init()
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        
        if let screen = dictionary["screen_name"] {
            self.screenName = screen as? String
        }
        
        if let profileImageUrl: String = dictionary["profile_image_url_https"] as? String {
            profilepic = URL(string: profileImageUrl)!
        }
        
        friendcount = dictionary["friends_count"] as? Int
        followercount = dictionary["followers_count"] as? Int
        statusCount = dictionary["statuses_count"] as? Int
    }
    
    private static var _current: User?
    static var current: User?{
        get{
            let defaults = UserDefaults.standard
            if let userData = defaults.data(forKey: "currentUserData"){
                let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                return  User(dictionary: dictionary)
            }
            return nil
        }
        set(user){
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            }else{
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
}
