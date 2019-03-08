//
//  RxUtil.swift
//  Example
//
//  Created by 王芃 on 2018/10/23.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift
import Disk

extension ObservableType {
    func void() -> Observable<Void> {
        return map { _ in }
    }
    func startWith(_ factory: @escaping () -> Observable<E>) -> Observable<E> {
        let start = Observable<E>.deferred {
            factory()
        }
        return start.concat(self)
    }
}

public func handleError(_ err: Error) -> Error {
    switch err {
    case HttpClientError.clientSideError(let error):
        printError("Http Client Error \(error)")
        break
    case let HttpClientError.invalidResponse(response, data):
        printError("Server Error Response \(response), and returning data \(String(describing: data))")
        break
    case HttpClientError.invalidJsonObject:
        printError("Server returning an invalid json")
        break
    case HttpClientError.jsonDeserializationError(let err):
        printError("the json cannot be deserialized \(err)")
        break
    case let SmartError.server(errorCode, errorMessage):
        printError("Server Error Response, and returning error code \(String(describing: errorCode)) and message \(String(describing: errorMessage))")
        break
    case SmartError.loginInvalid(let errorMessage):
        printError("The account has been logged on another device, \(errorMessage)")
        NEED_LOGOUT.onNext(())
        break
    case SmartError.jdAccountNotBinded(let errorMessage):
        printError("JD Account Not Binded \(errorMessage)")
        NEED_REBIND.onNext(())
        break
    case SmartError.tokenInvalid(let errorMessage):
        printError("The access token is invalid \(errorMessage)")
        NEED_LOGOUT.onNext(())
        break
    case SmartError.jdTokenInvalid(let errorMessage):
        printError("The JD access token is invalid \(errorMessage)")
        NEED_REBIND.onNext(())
        break
    default:
        break
    }
    return err
}

public func convertErrorToString(error: Error) -> String {
    switch error {
    case HttpClientError.clientSideError(_):
        return "请检查网络，请求似乎没有发出"
    case let HttpClientError.invalidResponse(response, _):
        return "请求失败，服务错误码\(response.statusCode)"
    case HttpClientError.invalidJsonObject,
         HttpClientError.jsonDeserializationError(_):
        return "请求失败，数据格式错误"
    case let SmartError.server(code, message):
        return "\(message)(\(code))"
    case SmartError.loginInvalid(_):
        return "您的账号已在其他设备登录，如果不是本人授权，请及时更改密码！"
    case SmartError.jdAccountNotBinded(_):
        return "首创智慧家应用需要绑定京东账号才能正常使用"
    case SmartError.tokenInvalid(_):
        return "首创智慧家应用需要绑定京东账号才能正常使用"
    case SmartError.jdTokenInvalid(_):
        return "首创智慧家应用需要绑定京东账号才能正常使用"
    case let SCError.JdSmartError(code, message, _):
        return "京东云错误: \(message ?? "未知错误")(代码:\(code ?? -1))"
    case RxError.timeout:
        return "请求超时: 网络环境较差，请稍后再试"
    case QRError.unrecognized:
        return "该二维码不是京东智能产品"
    case QRError.dataLength:
        return "二维码解析错误，数据长度不足"
    case QRError.unsupportedDevice:
        return "暂不支持该产品"
    case QRError.valueNull:
        return "二维码数据错误"
    default:
        printError(error)
        return "哎呀，好像系统开小差了"
    }
}

func getAppData() -> Observable<AppData> {
    return Observable.create{ observer -> Disposable in
        do {
            let data = try Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
            observer.onNext(data)
            observer.onCompleted()
        } catch {
            observer.onCompleted()
        }
        return Disposables.create()
    }
}

func getHomeData() -> Observable<HomeInfo> {
    return Observable.create{ observer -> Disposable in
        do {
            let data = try Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
            if (data.homeInfo == nil) {
                observer.onCompleted()
            } else {
                observer.onNext(data.homeInfo!)
            }
        } catch {
            observer.onCompleted()
        }
        return Disposables.create()
    }
}
