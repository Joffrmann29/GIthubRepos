//
//  GHUserCell.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/12/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import UIKit

class GHUserCell: UITableViewCell {
    @IBOutlet weak var avatarImgView: UIImageView! {
        didSet {
            avatarImgView.layer.cornerRadius = avatarImgView.frame.size.width / 2
            avatarImgView.clipsToBounds = true
        }
    }
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numReposLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
