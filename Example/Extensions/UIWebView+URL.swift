//
//  UIWebView+URL.swift
//  Example
//
//  Created by 王芃 on 2019/2/23.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import URLNavigator

extension UIWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            loadRequest(request)
        }
    }
    
    func load(_ urlString: URLConvertible) {
        if let url = urlString.urlValue {
            let request = URLRequest(url: url)
            loadRequest(request)
        }
    }
}
