//
//  BannerService.swift
//  Example
//
//  Created by 王芃 on 2018/10/11.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Moya
import p2_OAuth2

enum HomeService {
    case banners
    case channels
    case scenes
}

let HomeProvider = MoyaProvider<HomeService>(requestClosure: MoyaUtils.requestClosure, plugins: [MoyaUtils.networkPlugin]).rx

// MARK: - TargetType Protocol Implementation
extension HomeService: TargetType {
    var baseURL: URL { return URL(string: AppEnv.authOpenIdBaseUrl)! }
    var path: String {
        switch self {
        case .banners:
            return "/banners"
        case .channels:
            return "/channels"
        case .scenes:
            return "/scenes"
        }
    }
    var method: Moya.Method {
        switch self {
        case .banners, .channels, .scenes:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .banners, .channels, .scenes:// Send no parameters
            return .requestPlain
        }
    }
    var sampleData: Data {
        switch self {
        case .banners:
            return "[{\"id\":  \"123\", \"imageUrl\": \"http://image.loc/1.png\", \"label\": \"the first image\", \"link\": \"http://google.com\"}]".utf8Encoded
        case .channels:
            return "[{\"id\":  \"123\", \"imageUrl\": \"http://image.loc/1.png\", \"label\": \"the first image\", \"link\": \"http://google.com\"}]".utf8Encoded
        case .scenes:
            return "[{\"id\":  \"123\", \"imageUrl\": \"http://image.loc/1.png\", \"label\": \"the first image\", \"link\": \"http://google.com\"}]".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
