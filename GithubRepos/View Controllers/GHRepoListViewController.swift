//
//  ViewController.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/11/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import UIKit
import MBProgressHUD

class GHRepoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    @IBOutlet weak var tableView: UITableView!
    var resultSearchController = UISearchController()
    var userViewModel = GHUserViewModel(ghUsers: [])
    var users: [GHUser]? {
        didSet {
            tableView.reloadData()
        }
    }
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showIndicator(view: self.view, title: "Loading", description: "Retrieving Users...")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = .white
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.title = "Github Users"
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
            controller.searchBar.placeholder = "Search for Users"
            controller.isActive = self.searchActive
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        GHAPIService.shared.retrieveGHUsers(urlStr: Constants.usersURL) { (users) in
            guard let users = users else {
                DispatchQueue.main.async {
                    MBProgressHUD.hideIndicator(view: self.view)
                }
                return
            }
            for user in users {
                if let avatar_url = user.avatar_url {
                    GHAPIService.shared.getImageForAvatarURL(avatarImgURL: avatar_url) { (img) in
                        user.avatarImg = img
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                GHAPIService.shared.getProfileInfo(user: user) { (profile) in
                    self.userViewModel.ghUsers.append(user)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        MBProgressHUD.hideIndicator(view: self.view)
                    }
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
            return self.users!.count
        }
        else {
            return self.userViewModel.ghUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! GHUserCell
        var user: GHUser?
        
        if !self.searchActive {
            user = self.userViewModel.ghUsers[indexPath.row]
        }
        
        else if self.users?.count ?? 0 > indexPath.row {
            user = users?[indexPath.row]
        }
        
        cell.usernameLabel.text = user?.username
        cell.avatarImgView.image = user?.avatarImg
        if let numRepos = user?.numRepos {
            cell.numReposLabel.text = String(format: "Repo: %i", numRepos)
        }
        else {
            cell.numReposLabel.text = ""
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
        
        self.users = self.userViewModel.ghUsers.filter({ (user) -> Bool in
            var userFound = false

            let usernameRange = NSString(string: user.username!).range(of: searchString!, options: String.CompareOptions.caseInsensitive)
            userFound = usernameRange.location != NSNotFound
            
            
            return userFound
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueID = segue.identifier {
            if segueID == "toProfile" {
                let destinationVC = segue.destination as? GHProfileViewController
                if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
                    destinationVC?.passedUser = self.searchActive ? self.users?[selectedIndexPath.row] :  self.userViewModel.ghUsers[selectedIndexPath.row]
                }
            }
        }
    }
}

