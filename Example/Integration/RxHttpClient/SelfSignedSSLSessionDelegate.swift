//
//  SelfSignedSSLSessionDelegate.swift
//  Example
//
//  Created by 王芃 on 2019/1/26.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Foundation

class SelfSignedSSLSessionDelegate: NSURLSessionDataEventsObserver {
    
    /**
     处理自签名 SSL 证书
     */
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            if(challenge.protectionSpace.host == "www.bclsmartlife.com") {
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
            }
        }
    }
}
