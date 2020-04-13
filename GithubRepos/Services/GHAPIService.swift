//
//  GHAPIService.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/11/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let usersURL = "https://api.github.com/users"
    static let individualUserURL = "https://api.github.com/users"
    static let baseURL = "https://api.github.com/users"
    static var encryptedToken = "N2I0ZWQxZjg2ZGY0MzJhN2IxMzBjNzI5MTI5Mzc1YWEwZDc5ZjBlNQ=="
}

class GHAPIService {
    static let shared = GHAPIService()
    let session = URLSession.shared
    let userCache = NSCache<NSString, GHUser>()
    let repoCache = NSCache<NSString, GHRepo>()
    
    private init() { }
    
    func getDecryptedToken() -> String {
        guard let token = Constants.encryptedToken.fromBase64() else {
            return ""
        }
        return token
    }
    
    func retrieveGHUsers(urlStr: String, completion: @escaping (_ users: [GHUser]?)-> Void) {
        var users = [GHUser]()
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        
        request.addValue(getDecryptedToken(), forHTTPHeaderField: "Authorization: token")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                for user in jsonData {
                    guard let avatar_url = user["avatar_url"] as? String, let login = user["login"] as? String, let repoURL = user["repos_url"] as? String else {
                        completion(nil)
                        return
                    }
                    let ghUser = GHUser(avatar_url: avatar_url, username: login, repoURL: repoURL)
                    if !users.contains(ghUser) {
                        users.append(ghUser)
                    }
                }
                completion(users)
            }
        }
        
        task.resume()
    }
    
    func getImageForAvatarURL(avatarImgURL: String, completion: @escaping (_ img: UIImage?)-> Void) {
            let url = URL(string: avatarImgURL)!
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                guard let imgData = data else {
                    completion(nil)
                    return
                }
                guard let img = UIImage(data: imgData) else {
                    completion(nil)
                    return
                }
                completion(img)
            })
            
            task.resume()
        }
        
    func getProfileInfo(user: GHUser, completion: @escaping (_ user: GHUser?)-> Void) {
        guard let username = user.username else {
            completion(nil)
            return
        }
        let urlString = String(format: "%@/%@", Constants.individualUserURL, username)
        let url = URL(string: urlString)!
        
        if let cachedObject = userCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedObject)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(getDecryptedToken(), forHTTPHeaderField: "Authorization: token")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            if let profile = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                if let numRepos = profile["public_repos"] as? Int {
                    user.numRepos = numRepos
                }
                if let numFollowers = profile["followers"] as? Int {
                    user.numFollowers = numFollowers
                }
                if let numFollowing = profile["following"] as? Int {
                    user.numFollowing = numFollowing
                }
                if let bio = profile["bio"] as? String {
                    user.bio = bio
                }
                if let email = profile["email"] as? String {
                    user.email = email
                }
                if let location = profile["location"] as? String {
                    user.location = location
                }
                if let joinDate = profile["created_at"] as? String {
                    user.joinDate = joinDate
                }
                completion(user)
            }
        }
        
        task.resume()
    }
        
    func getUserRepos(user: GHUser, completion: @escaping (_ repos: GHRepo)-> Void) {
        guard let reposURL = user.repoURL else {
            return
        }
        let url = URL(string: reposURL)!
        
        if let cachedObject = repoCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedObject)
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(getDecryptedToken(), forHTTPHeaderField: "Authorization: token")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                for dict in jsonData {
                    guard let repoName = dict["name"] as? String, let url = dict["html_url"] as? String, let numForks = dict["forks_count"] as? Int, let numStars = dict["stargazers_count"] as? Int else {
                        return
                    }
                    let ghRepo = GHRepo(name: repoName, url: url, stargazers_count: numStars, fork_count: numForks)
                    completion(ghRepo)
                }
            }
        })
        
        task.resume()
    }
}
