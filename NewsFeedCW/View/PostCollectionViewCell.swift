//
//  PostCollectionViewCell.swift
//  NewsFeedCW
//
//  Created by developersancho on 28.10.2018.
//  Copyright © 2018 developersancho. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        profileImageView.image = post.createdBy.profileImage
        profileImageView.layer.cornerRadius = 3.0
        profileImageView.layer.masksToBounds = true
        
        usernameLabel.text = post.createdBy.username
        timeAgoLabel.text = post.timeAgo
        captionLabel.text = post.caption
        
        postImageView.image = post.image
        postImageView.layer.cornerRadius = 5.0
        postImageView.layer.masksToBounds = true
    }
    
}
