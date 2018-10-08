//
//  MeViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/1.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {
    private let authService = container.resolve(OAuth2Service.self)!
    @objc private var logoutButton: UIButton?
    
    @objc func logout() -> Void {
        self.authService.logout()
        AppDelegate.shared.rootViewController.switchToLogout()
    }
}
