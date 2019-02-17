//
//  JdSmartCloudService.swift
//  Example
//
//  Created by 王芃 on 2018/11/12.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import SCMSDK
import RxSwift
import ObjectMapper

public enum ProductVersion {
    case two
    case three
    
    var verVal: String {
        switch self {
        case .two:
            return "2.0"
        case .three:
            return "3.0"
        }
    }
}

enum SCError: Error {
    case JdSmartError(_ code: Int?, _ message: String?, _ debug: String?)
}

class JdSmartCloudService {
    public func initSmartCloud() {
        print("enter initSmartCloud")
        #if !targetEnvironment(simulator)
        let appKey = AppEnv.smartCloudAppKey
        let data = DiskUtil.getData()
        guard let token = data?.houseToken else {
            print("[JdSmartCloudService] 房主 token 不存在")
            return
        }
        SCMInitManager.sharedInstance().registerAppKey(appKey)
        print("[JdSmartCloudService] 为京东 SDK 设置 appkey \(appKey)")
        SCMInitManager.sharedInstance().registerUserToken(token)
        print("[JdSmartCloudService] 为京东 SDK 设置 token \(token)")
        SCMInitManager.sharedInstance().startLoop()
        SCMLongConnectManager.shared().createLongConnect()
        #endif
        print("exit initSmartCloud")
    }
    
    public func changeToken() {
        print("enter changeToken")
        #if !targetEnvironment(simulator)
        let data = DiskUtil.getData()
        guard let token = data?.houseToken else {
            print("[JdSmartCloudService] 房主 token 不存在")
            return
        }
        if(SCMLongConnectManager.shared().isConnecting()) {
            SCMLongConnectManager.shared().cutOffLongConnect()
        }
        SCMInitManager.sharedInstance().stopLoop()
        SCMInitManager.sharedInstance().registerUserToken(token)
        print("[JdSmartCloudService] 为京东 SDK 设置 token \(token)")
        SCMInitManager.sharedInstance().startLoop()
        SCMLongConnectManager.shared().createLongConnect()
        #endif
        print("exit changeToken")
    }
    
    public func initLongPolling(userToken: String) {
        print("enter initLongPolling")
        #if !targetEnvironment(simulator)
        if (SCMLongConnectManager.shared().isConnecting()) {
            SCMLongConnectManager.shared().cutOffLongConnect()
        }
        SCMInitManager.sharedInstance().registerUserToken(userToken)
        SCMLongConnectManager.shared().createLongConnect()
        #endif
        print("exit initLongPolling")
    }
    
    public func getScenes(page: Int, pageSize: Int? = 30, extend: [AnyHashable : Any]? = nil) {
        print("enter getScenes")
        #if !targetEnvironment(simulator)

        SCMIFTTTManager.getIFTTTList(page, pageSize: pageSize!, extend: extend) { (dict) in
            let result = dict! as NSDictionary
            print(result["status"] ?? "Not Returning Status Value")
        }
        #endif
        print("exit getScenes")
    }
    
    public func bindJdAccount(vc: UIViewController) {
        print("enter bindJdAccount")
        #if !targetEnvironment(simulator)
        SCMAuthorizedInitManager.shared()?.showAuthorizeViewController(withRootController: vc, state: "", redirectUrl: "https://116.196.81.233")
        #endif
        print("exit bindJdAccount")
    }
    
    public func deviceSnapshotV2(id: String) -> Observable<SCV2Snapshot?> {
        print("enter deviceSnapshot")
        return Observable<SCV2Snapshot?>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMCloudControlManager.getSnapShot(
                withVersion: "2.0",
                digest: nil,
                feedId: id,
                guid: nil,
                success: { (res) in
                    let res = res as! [String: Any]
                    let result = Mapper<SmartCloudResult>().map(JSON: res)
                    guard result?.status == 0 else {
                        printError(result?.error)
                        observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                        return
                    }
                    let snapshot = Mapper<SCV2Snapshot>().map(JSONString: (result?.result)!)
                    print(snapshot?.toDictionary())
                    observer.onNext(snapshot)
                    observer.onCompleted()
                },
                fail: { error in
                    printError(error)
                    observer.onError(error!)
                })
            #endif
            return Disposables.create()
        }
    }
    
    func getDeviceH5V2(_ version: String, _ feedId: String) -> Observable<String> {
        print("enter getDeviceH5V2")
        return Observable<String>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMCloudControlManager.getDeviceUrl(
                withVersion: version,
                feedId: feedId,
                puid: nil,
                service: nil,
                success: { (data) in
                    let res = data as! [String: Any]
                    let result = Mapper<SmartCloudResult>().map(JSON: res)
                    guard result?.status == 0 else {
                        printError(result?.error)
                        observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                        return
                    }
                    let deviceUrl = Mapper<SCDeviceUrl>().map(JSONString: (result?.result)!)
                    observer.onNext(deviceUrl?.h5?.url ?? "")
                    observer.onCompleted()
                }) { (error) in
                    printError(error)
                    observer.onError(error!)
                }
            #endif
            return Disposables.create()
        }
    }
}
