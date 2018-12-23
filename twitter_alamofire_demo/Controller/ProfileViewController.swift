//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by peter on 12/22/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var statusCountLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateAllContent()
        clipProfileImage()
        // Do any additional setup after loading the view.
    }
    
    // Backend Variables
    var user : User?
    
    // Graphic Design Methods
    func updateAllContent() {
        if let user = self.user {
            if let propicURL = user.profilepic {
                profilePicture.af_setImage(withURL: propicURL)
            }
            realNameLabel.text = user.name
            usernameLabel.text = "@\(user.screenName!)"
            followerLabel.text = "\(user.followercount!)"
            followingLabel.text = "\(user.friendcount!)"
            statusCountLabel.text = "\(user.statusCount!)"
            
        }
    }
    
    func clipProfileImage() {
        profilePicture.layer.cornerRadius = profilePicture.layer.frame.height/2
        profilePicture.clipsToBounds = true
        profilePicture.layer.borderWidth = 1.5
        profilePicture.layer.borderColor = UIColor.black.cgColor
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
