//
//  AuthService.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Moya
import p2_OAuth2

let oauth2 = container.resolve(OAuth2PasswordGrant.self)!

let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    let request = try! endpoint.urlRequest() // This is the request Moya generates
    var req = oauth2.request(forURL: request.url!)
    done(.success(req))
}

enum AuthService {
    case login(username: String, password: String)
    case register(user: User)
    case updateUser(id: String, user: User)
    case profile
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let AuthProvider = MoyaProvider<AuthService>(requestClosure: requestClosure, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]).rx

// MARK: - TargetType Protocol Implementation
extension AuthService: TargetType {
    var baseURL: URL { return URL(string: AppEnv.authOpenIdBaseUrl)! }
    var path: String {
        switch self {
        case .profile:
            return "/profile"
        case .login(_, _):
            return "/auth/login"
        case .updateUser(let id, _):
            return "/users/\(id)"
        case .register(_):
            return "/auth/register"
        }
    }
    var method: Moya.Method {
        switch self {
        case .profile:
            return .get
        case .login, .register, .updateUser:
            return .post
        }
    }
    var task: Task {
        switch self {
        case .profile:// Send no parameters
            return .requestPlain
        case .updateUser(_, let user), .register(let user):  // Always sends parameters in URL, regardless of which HTTP method is used
            return .requestParameters(parameters: ["login": user.login, "mobile": user.mobile, "email": user.email, "name": user.name], encoding: JSONEncoding.default)
        case .login(let login, let password): // Always send parameters as JSON in request body
            return .requestParameters(parameters: ["login": login, "password": password], encoding: JSONEncoding.default)
        }
    }
    var sampleData: Data {
        switch self {
        case .profile:
            return "{\"id\":  \"123\", \"name\": \"admin\", \"mobile\": \"13012341234\", \"email\": \"admin@local.dev\", \"avatar\": \"avatar-01\", \"authorities\": [\"ROLE_ADMIN\"]}".utf8Encoded
        case .login(_, _):
            return "{\"id_token\": \"123.446.789\", \"refresh_token\": \"123.456.789\"}".utf8Encoded
        case .updateUser(let id, let user):
            return User(id: id, login: user.login!, mobile: user.mobile!, email: user.email!, name: user.name!).toJSONString()!.utf8Encoded
        case .register(let user):
            return User(id: "123", login: user.login!, mobile: user.mobile!, email: user.email!, name: user.name!).toJSONString()!.utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
