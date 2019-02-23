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
        let registerScreen = UINavigationController(rootViewController: SignUpViewController())
        UINavigationBar.appearance().backgroundColor = .primary
        UINavigationBar.appearance().barTintColor = .textIcon
        UINavigationBar.appearance().isTranslucent = false
        
        let navigationTitleAttributes = {
            return [ NSAttributedString.Key.foregroundColor: UIColor.textIcon ]
        }()
        UINavigationBar.appearance().tintColor = .textIcon
        
        UIBarButtonItem.appearance().setTitleTextAttributes(navigationTitleAttributes as [NSAttributedString.Key : Any], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttributes as [NSAttributedString.Key : Any]
        animateDismissTransition(to: registerScreen)
    }
    
    func switchToLogout() {
        if let visibleViewCtrl = UIApplication.shared.topMostViewController() {
            if (visibleViewCtrl.isKind(of: AuthViewController.self)) {
                return
            }
            let loginViewController = AuthViewController()
            let logoutScreen = UINavigationController(rootViewController: loginViewController)
            animateDismissTransition(to: logoutScreen)
        }
    }
    
    func switchToTour() {
        let tourViewController = TourViewController()
        let tourScreen = UINavigationController(rootViewController: tourViewController)
        tourScreen.hideTransparentNavigationBar()
        animateDismissTransition(to: tourScreen)
    }
    
    func switchToHome() -> Void {
        let homeVC = HomeViewController()
        let homeScreen = UINavigationController(rootViewController: homeVC)
        animateFadeTransition(to: homeScreen) { [weak self] in
            self?.handleDeeplink(self?.deeplink)
        }
    }
    
    func switchToBindJdAccount() {
        let new = UINavigationController(rootViewController: BindJdAccountViewController())
        addChild(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParent: self)
        
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        
        current = new
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
        guard current is HomeViewController else { return }
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
