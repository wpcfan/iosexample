//
//  NavigationMap.swift
//  URLNavigatorExample
//
//  Created by Suyeol Jeon on 7/12/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//

import UIKit
import PMAlertController
import URLNavigator
import RxQRScanner
import PinLayout

enum NavigationMap {
    static func initialize(navigator: NavigatorType) {
        navigator.register("\(Constants.NAVI_PREFIX)://home") { url, values, context in
            let viewController = HomeViewController()
            return viewController;
        }
        navigator.register("\(Constants.NAVI_PREFIX)://home/myhouses") { url, values, context in
            let viewController = HouseTableViewController()
            return viewController;
        }
        
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)
        
        navigator.handle("\(Constants.NAVI_PREFIX)://alert", self.alert(navigator: navigator))
        navigator.handle("\(Constants.NAVI_PREFIX)://pmalert", self.pmAlert(navigator: navigator))
        navigator.handle("\(Constants.NAVI_PREFIX)://<path:_>") { (url, values, context) -> Bool in
            // No navigator match, do analytics or fallback function here
            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
            return true
        }
    }
    
    private static func webViewControllerFactory(
        url: URLConvertible,
        values: [String: Any],
        context: Any?
        ) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
        guard let pageTitle = url.queryParameters["title"] else {
            return WebKitViewController(url: url)
        }
        return WebKitViewController(url: url, pageTitle: pageTitle)
    }
    
    private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(
                title:"pmalert.ok.title".localized,
                style: .default,
                handler: nil))
            navigator.present(alertController)
            return true
        }
    }
    
    private static func pmAlert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertVC = PMAlertController(title: title, description: message ?? "", image: AppIcons.sceneHomeAccent, style: .alert)
            
            alertVC.addAction(PMAlertAction(
                title: "pmalert.cancel.title".localized,
                style: .cancel,
                action: { () -> Void in
                    print("Capture action Cancel")
                }))
            
            alertVC.addAction(PMAlertAction(
                title:"pmalert.ok.title".localized,
                style: .default,
                action: { () in
                    print("Capture action OK")
                }))
            
            navigator.present(alertVC)
            return true
        }
    }
}
