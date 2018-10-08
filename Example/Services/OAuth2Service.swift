//
//  OAuth2Service.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Foundation
import p2_OAuth2
import KTVJSONWebToken
import RxSwift

class OAuth2Service {
    private let oauth2 = container.resolve(OAuth2PasswordGrant.self)!
    
    public func login(username: String, password: String) -> Observable<OAuth2JSON> {
        self.oauth2.username = username
        self.oauth2.password = password
        self.oauth2.logger = OAuth2DebugLogger(.trace)
        return self.oauth2.rx_authorize()
    }
    
    public func logout() {
        self.oauth2.forgetTokens()
    }
}
