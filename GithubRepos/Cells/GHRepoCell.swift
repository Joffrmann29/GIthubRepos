//
//  GHRepoCell.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/12/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import UIKit

class GHRepoCell: UITableViewCell {
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var numForksLabel: UILabel!
    @IBOutlet weak var numStarsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
