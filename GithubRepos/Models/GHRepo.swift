//
//  GHRepo.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/11/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import Foundation

class GHRepo {
    var name: String?
    var url: String?
    var stargazers_count: Int?
    var fork_count: Int?
    
    init(name: String?, url: String?, stargazers_count: Int?, fork_count: Int?) {
        self.name = name
        self.url = url
        self.stargazers_count = stargazers_count
        self.fork_count = fork_count
    }
}
