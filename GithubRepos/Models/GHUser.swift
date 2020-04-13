//
//  GHUser.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/11/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import Foundation
import UIKit

class GHUser: Equatable {
    var avatar_url: String?
    var username: String?
    var repoURL: String?
    var avatarImg: UIImage?
    var numRepos: Int?
    var numFollowers: Int?
    var numFollowing: Int?
    var bio: String?
    var email: String?
    var location: String?
    var joinDate: String?
    var repos: [GHRepo]?
    
    init(avatar_url: String?, username: String?, repoURL: String?) {
        self.avatar_url = avatar_url
        self.username = username
        self.repoURL = repoURL
    }
    
    static func == (lhs: GHUser, rhs: GHUser) -> Bool {
        return lhs.username == rhs.username && lhs.avatar_url == rhs.avatar_url && lhs.repoURL == rhs.repoURL
    }
}
