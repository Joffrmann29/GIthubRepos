//
//  GHProfileViewModel.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/11/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import Foundation

struct GHProfileViewModel {
    var user: GHUser?
    
    init(user: GHUser?) {
        self.user = user
    }
}
