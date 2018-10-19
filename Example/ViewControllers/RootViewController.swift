//
//  RootViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/5.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import SafariServices

class RootViewController: UIViewController {
    private var current: UIViewController
    
    var deeplink: DeeplinkType? {
        didSet {
            handleDeeplink()
        }
    }
    
    init() {
        self.current = SplashViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let registerScreen = UINavigationController(rootViewController: RegisterViewController())
        UINavigationBar.appearance().barTintColor = UIColor.accent
        UINavigationBar.appearance().isTranslucent = false
        let navigationTitleAttributes = {
            return [ NSAttributedString.Key.foregroundColor: UIColor.primary ]
        }()
        UINavigationBar.appearance().tintColor = UIColor.primary
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
//        let mainScreen = MainNavigationController(rootViewController: mainViewController)
//        UINavigationBar.appearance().barTintColor = UIColor.accent
//        UINavigationBar.appearance().isTranslucent = false
//        let navigationTitleAttributes = {
//            return [ NSAttributedString.Key.foregroundColor: UIColor.primary ]
//        }()
//        UINavigationBar.appearance().tintColor = .white
//        UIBarButtonItem.appearance().setTitleTextAttributes(navigationTitleAttributes as [NSAttributedString.Key : Any], for: .normal)
//        UINavigationBar.appearance().titleTextAttributes = navigationTitleAttributes as [NSAttributedString.Key : Any]
//        mainScreen.presentTransparentNavigationBar()
//        mainScreen.hideTransparentNavigationBar()
        animateFadeTransition(to: mainViewController) { [weak self] in
            self?.handleDeeplink()
        }
    }
    
    func switchWebView(url: String) {
        let viewController = SFSafariViewController(url: URL(string: url)!)
        let viewScreen = UINavigationController(rootViewController: viewController)
        animateDismissTransition(to: viewScreen)
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
    
    private func handleDeeplink() {
        if let mainNavigationController = current as? MainNavigationController, let deeplink = deeplink {
            switch deeplink {
            case .activity:
                mainNavigationController.popToRootViewController(animated: false)
            default:
                // handle any other types of Deeplinks here
                break
            }
            
            // reset the deeplink back no nil, so it will not be triggered more than once
            self.deeplink = nil
        }
    }
}
