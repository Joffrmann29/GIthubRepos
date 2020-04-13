//
//  GHUser.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/11/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import Foundation

struct GHUser: Codable {
    var avatar_url: String?
    var login: String?
    var numRepos: Int?
    
    init(avatar_url: String?, login: String?, numRepos: Int?) {
        self.avatar_url = avatar_url
        self.login = login
        self.numRepos = numRepos
    }
}
