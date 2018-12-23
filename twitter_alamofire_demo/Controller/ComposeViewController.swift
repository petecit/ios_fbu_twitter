//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by peter on 12/22/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate : class {
    func did(post : Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    // Backend Variables
    weak var delegate: ComposeViewControllerDelegate?
    var characterLimit : Int = 141
    var user : User?
    var isReply : Bool = false
    var replyName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postButton.isEnabled = false
        tweetTextView.textColor = UIColor.lightGray
        tweetTextView.delegate = self as UITextViewDelegate
        charCountLabel.text = "Character Count: 0"
        updateUserInformation()
    }
    
    func updateUserInformation() {
        if let user = user {
            realNameLabel.text = user.name
            usernameLabel.text = "@\(user.screenName!)"
            if let propicURL = user.profilepic {
                profilePicture.af_setImage(withURL: propicURL)
            }
            
        }
        if (isReply), let replyName = self.replyName {
            tweetTextView.text = "@\(replyName) "
            tweetTextView.textColor = UIColor.black
        }
    }
    
    // event handlers
    @IBAction func onTapPost(_ sender: Any) {
        let tweetText = tweetTextView.text!
        APIManager.shared.composeTweet(with: tweetText) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
            }
        }
        self.performSegue(withIdentifier: "ReturnSegue", sender: nil)
    }
    
    
    @IBAction func onTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        APIManager.shared.updateTweetCount(user: User.current)
    }
    
    
    @IBAction func onTapElsewhere(_ sender: Any) {
        view.endEditing(true)
    }
    
    // Delegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        let current = newText.count
        charCountLabel.text = "Character Count: \(current)"
        if (current == 0) {
            postButton.isEnabled = false
            return true;
        }
        postButton.isEnabled = true
        if (current < characterLimit) {
            charCountLabel.textColor = UIColor.lightGray
            return true
        } else {
            charCountLabel.textColor = UIColor.red
            if (current == characterLimit) {
                charCountLabel.text = "Character Count: 140"
            }
            return false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor == UIColor.lightGray) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text.count == 0) {
            textView.text = "Write a post..."
            textView.textColor = UIColor.lightGray
            postButton.isEnabled = false
        }
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
