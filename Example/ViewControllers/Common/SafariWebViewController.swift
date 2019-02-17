//
//  SafariWebViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/17.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import SafariServices

class SafariWebViewController: SFSafariViewController {
    override init(url URL: URL, entersReaderIfAvailable: Bool) {
        super.init(url: URL, entersReaderIfAvailable: entersReaderIfAvailable)
        delegate = self
        
        if #available(iOS 10.0, *) {
            preferredBarTintColor = .primary
            preferredControlTintColor = .white
        }
    }
}

extension SafariWebViewController: SFSafariViewControllerDelegate {
    internal func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
}
