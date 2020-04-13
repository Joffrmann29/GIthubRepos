//
//  GHRepo.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/11/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import Foundation

struct GHRepo {
    var name: String?
    var stargazers_count: String?
    var fork_count: String?
    
    init(name: String?, stargazers_count: String?, fork_count: String?) {
        self.name = name
        self.stargazers_count = stargazers_count
        self.fork_count = fork_count
    }
}
