//
//  OAuth2Service.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import p2_OAuth2
import KTVJSONWebToken
import RxSwift

class OAuth2Service {
    private let oauth2Password = container.resolve(OAuth2PasswordGrant.self)!
    private let oauth2Code = container.resolve(OAuth2CodeGrant.self)!
    
    public func loginWithUserCredential(username: String, password: String) -> Observable<OAuth2JSON> {
        oauth2Password.username = username
        oauth2Password.password = password
        oauth2Password.logger = OAuth2DebugLogger(.trace)
        return oauth2Password.rx_authorize()
    }
    
    public func autoLogin() -> Observable<OAuth2JSON> {
        oauth2Password.logger = OAuth2DebugLogger(.trace)
        return oauth2Password.rx_authorize()
    }
    
    public func logout() {
        oauth2Password.forgetTokens()
        oauth2Code.forgetTokens()
    }
    
    public func checkLoginStatus() -> Bool {
        if (oauth2Password.refreshToken == nil) {
            return false
        }
        let validator = RegisteredClaimValidator.expiration &
            RegisteredClaimValidator.notBefore.optional
        let jwt : JSONWebToken = try! JSONWebToken(string: oauth2Password.refreshToken!)
        let validationResult = validator.validateToken(jwt)
        guard case ValidationResult.success = validationResult else { return false }
        return true
    }
}
