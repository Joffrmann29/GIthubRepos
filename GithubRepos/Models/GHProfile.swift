//
//  GHProfile.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/11/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import Foundation

struct GHProfile: Codable {
    var avatar_url: String?
    var login: String?
    var numRepos: Int?
    var numFollowers: Int?
    var numFollowing: Int?
    var bio: String?
    var email: String?
    var location: String?
    var joinDate: String?
    var reposURL: String?
    
    init(avatar_url: String?, login: String?, numRepos: Int?, numFollowers: Int?, numFollowing: Int?, bio: String?, email: String?, location: String?, joinDate: String?, reposURL: String?) {
        self.avatar_url = avatar_url
        self.login = login
        self.numRepos = numRepos
        self.numFollowers = numFollowers
        self.numFollowing = numFollowing
        self.bio = bio
        self.email = email
        self.location = location
        self.joinDate = joinDate
        self.reposURL = reposURL
    }
}
