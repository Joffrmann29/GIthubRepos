//
//  GHProfileViewController.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/11/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import UIKit
import MBProgressHUD

class GHProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    var passedUser:GHUser? = nil
    var repos = [GHRepo]()
    var filteredRepos = [GHRepo]() {
        didSet {
            tableView.reloadData()
        }
    }
    var resultSearchController = UISearchController()
    var searchActive : Bool = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var profileImgView: UIImageView! {
        didSet {
            profileImgView.layer.cornerRadius = profileImgView.frame.size.width / 2
            profileImgView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showIndicator(view: self.view, title: "Loading", description: "Retrieving User Repos...")
        self.tableView.backgroundColor = .white
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = "Profile"
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.frame = CGRect(x: controller.searchBar.frame.origin.x, y: controller.searchBar.frame.origin.y, width: self.view.frame.size.width, height:controller.searchBar.frame.size.height)
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor = UIColor.clear
            controller.definesPresentationContext = true
            controller.searchBar.placeholder = "Search for User's Repositories"
            controller.isActive = self.searchActive
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        if let user = self.passedUser {
            self.usernameLabel.text = user.username
            self.emailLabel.text = user.email
            self.locationLabel.text = user.location
            self.joinDateLabel.text = user.joinDate
            if let numFollowers = user.numFollowers {
                self.followersLabel.text = String(format: "%i Followers", numFollowers)
            }
            if let numFollowing = user.numFollowing {
                self.followingLabel.text = String(format: "Following %i", numFollowing)
            }
            self.profileImgView.image = user.avatarImg
            if let bio = user.bio {
                self.bioLabel.text = bio
            }
            else {
                self.bioLabel.isHidden = true
                self.tableTopConstraint.constant = 0
            }
            GHAPIService.shared.getUserRepos(user: user) { (repo) in
                self.repos.append(repo)
                DispatchQueue.main.async {
                    MBProgressHUD.hideIndicator(view: self.view)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.resultSearchController.searchBar.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.navigationItem.titleView = nil
        self.resultSearchController.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive {
            return self.filteredRepos.count
        }
        else {
            return self.repos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! GHRepoCell
        var repo: GHRepo?
        
        if self.searchActive {
            repo = self.filteredRepos[indexPath.row]
        }
        
        else {
            repo = self.repos[indexPath.row]
        }
        
        cell.repoNameLabel.text = repo?.name
        if let numForks = repo?.fork_count {
            cell.numForksLabel.text = String(format: "%i Forks", numForks)
        }
        if let numStars = repo?.stargazers_count {
            cell.numStarsLabel.text = String(format: "%i Stars", numStars)
        }
        
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.tableView.reloadData()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        self.filteredRepos = self.repos.filter({ (repo) -> Bool in
            var repoFound = false

            if let name = repo.name {
                let nameRange = NSString(string: name).range(of: searchString!, options: String.CompareOptions.caseInsensitive)
                repoFound = nameRange.location != NSNotFound
            }
            
            return repoFound
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueID = segue.identifier {
            if segueID == "toWebView" {
                let destinationVC = segue.destination as? GHRepoWebViewController
                if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                    destinationVC?.repo = self.searchActive ? self.filteredRepos[selectedIndexPath.row] :  self.repos[selectedIndexPath.row]
                }
            }
        }
    }
}
