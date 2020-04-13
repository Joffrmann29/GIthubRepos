//
//  GHRepoWebViewController.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/13/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import UIKit
import WebKit

class GHRepoWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var repo: GHRepo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let repoName = self.repo?.name, let url = self.repo?.url else {
            return
        }
        self.navigationItem.title =  repoName
        self.webView.load(url)
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
