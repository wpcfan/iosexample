//
//  CaptchaService.swift
//  Example
//
//  Created by 王芃 on 2019/2/12.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import Disk

class CaptchaService {
    let client = container.resolve(HttpClient.self)!
    let baseUrl = AppEnv.apiBaseUrl
    var smartApi: SmartApiType {
        get { return .getCaptcha }
    }
    func request() -> Observable<UIImage?> {
        var urlComponents = URLComponents(string: "\(baseUrl)\(smartApi.entityPath)")!
        let queries = urlQueries()
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        urlComponents.queryItems = queries
        return self.client
            .requestData(url: urlComponents.url!, method: .post, body: nil, httpHeaders: headers)
            .map({ (data) -> UIImage? in
                UIImage(data: data)
            })
    }
    
    func urlQueries() -> [URLQueryItem] {
        let appData = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        return [URLQueryItem(name: "p1", value: appData?.token)]
    }
}
