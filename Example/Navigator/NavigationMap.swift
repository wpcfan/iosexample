//
//  NavigationMap.swift
//  URLNavigatorExample
//
//  Created by Suyeol Jeon on 7/12/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//
import SafariServices
import UIKit

import URLNavigator

enum NavigationMap {
    static func initialize(navigator: NavigatorType) {
        navigator.register("example://home/<tabname>") { url, values, context in
            guard let tabname = values["tabname"] as? String else { return nil }
            let homeTabViewController = HomeTabViewController(tabName: tabname)
            return homeTabViewController;
        }
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)
        
        navigator.handle("example://alert", self.alert(navigator: navigator))
        navigator.handle("example://<path:_>") { (url, values, context) -> Bool in
            // No navigator match, do analytics or fallback function here
            log.debug("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
            return true
        }
    }
    
    private static func webViewControllerFactory(
        url: URLConvertible,
        values: [String: Any],
        context: Any?
        ) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
        return SFSafariViewController(url: url)
    }
    
    private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
    }
}
