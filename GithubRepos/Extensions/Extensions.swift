//
//  Extensions.swift
//  GithubRepos
//
//  Created by Joffrey Mann on 4/13/20.
//  Copyright © 2020 Joffrey Mann. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    static func showIndicator(view: UIView, title: String, description:String) {
      let indicator = MBProgressHUD.showAdded(to: view, animated: true)
      indicator.label.text = title
      indicator.isUserInteractionEnabled = false
      indicator.detailsLabel.text = description
      indicator.show(animated: true)
   }
    
    static func hideIndicator(view: UIView) {
      MBProgressHUD.hide(for: view, animated: true)
   }
}
