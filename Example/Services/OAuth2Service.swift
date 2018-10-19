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
import RxCocoa

class OAuth2Service {
    private let oauth2 = container.resolve(OAuth2PasswordGrant.self)!
    
    public func loginWithUserCredential(username: String, password: String) -> Observable<Void> {
        return oauth2.rx.authorizeWithCredential(username: username, password: password)
    }
    
    public func logout() {
        oauth2.forgetTokens()
    }
    
    public func checkLoginStatus() -> Bool {
        if (oauth2.refreshToken == nil) {
            return false
        }
        let validator = RegisteredClaimValidator.expiration &
            RegisteredClaimValidator.notBefore.optional
        let jwt : JSONWebToken = try! JSONWebToken(string: oauth2.refreshToken!)
        let validationResult = validator.validateToken(jwt)
        guard case ValidationResult.success = validationResult else { return false }
        return true
    }
}
