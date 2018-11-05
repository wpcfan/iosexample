//
//  RootViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/5.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import p2_OAuth2
import RxQRScanner
import RxSwift

class RootViewController: BaseViewController {
    private var current: UIViewController
    private let oauth2 = container.resolve(OAuth2PasswordGrant.self)!
    
    var deeplink: DeeplinkType? {
        didSet {
            handleDeeplink(deeplink)
        }
    }
    
    override init() {
        self.current = SplashViewController()
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func showLoginScreen() {
        oauth2.forgetTokens()
        let new = UINavigationController(rootViewController: AuthViewController())
        addChild(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParent: self)
        
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        
        current = new
    }
    
    func showRegisterScreen() {
        let registerScreen = UINavigationController(rootViewController: RegisterViewController())
        UINavigationBar.appearance().barTintColor = UIColor.textIcon
        UINavigationBar.appearance().isTranslucent = false
        
        let navigationTitleAttributes = {
            return [ NSAttributedString.Key.foregroundColor: UIColor.textIcon ]
        }()
        UINavigationBar.appearance().tintColor = UIColor.textIcon
        
        UIBarButtonItem.appearance().setTitleTextAttributes(navigationTitleAttributes as [NSAttributedString.Key : Any], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttributes as [NSAttributedString.Key : Any]
        animateDismissTransition(to: registerScreen)
    }
    
    func switchToLogout() {
        let loginViewController = AuthViewController()
        let logoutScreen = UINavigationController(rootViewController: loginViewController)
        animateDismissTransition(to: logoutScreen)
    }
    
    func switchToTour() {
        let tourViewController = TourViewController()
        let tourScreen = UINavigationController(rootViewController: tourViewController)
        tourScreen.hideTransparentNavigationBar()
        animateDismissTransition(to: tourScreen)
    }
    
    func switchToMainScreen() {
        let mainViewController = HomeTabViewController(tabName: "app")
        animateFadeTransition(to: mainViewController) { [weak self] in
            self?.handleDeeplink(self?.deeplink)
        }
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)
        new.view.frame = initialFrame
        
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    private func handleDeeplink(_ deepLink: DeeplinkType?) {
        guard deeplink != nil else { return }
        guard let homeController = current as? HomeTabViewController else { return }
        switch deepLink! {
        case .activity:
            print("[DeepLink] 捕获到 3D 触摸")
        default:
            // handle any other types of Deeplinks here
            break
        }
        
        // reset the deeplink back no nil, so it will not be triggered more than once
        self.deeplink = nil
    }
}
