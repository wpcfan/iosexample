//
//  JdSmartCloudService.swift
//  Example
//
//  Created by 王芃 on 2018/11/12.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import SCMSDK
import RxSwift
import RxCocoa
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
    
    public func bindJdAccount(vc: UIViewController) {
        print("enter bindJdAccount")
        #if !targetEnvironment(simulator)
        SCMAuthorizedInitManager.shared()?.showAuthorizeViewController(withRootController: vc, state: "", redirectUrl: "https://116.196.81.233")
        #endif
        print("exit bindJdAccount")
    }
    
    public func deviceSnapshotV2(feedId: String) -> Observable<JdV2Snapshot?> {
        print("enter deviceSnapshot")
        return Observable<JdV2Snapshot?>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMCloudControlManager.getSnapShot(
                withVersion: ProductVersion.two.verVal,
                digest: nil,
                feedId: feedId,
                guid: nil,
                success: { (res) in
                    let res = res as! [String: Any]
                    let result = Mapper<JdCloudResult>().map(JSON: res)
                    guard result?.status == 0 else {
                        printError(result?.error)
                        observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                        return
                    }
                    let snapshot = Mapper<JdV2Snapshot>().map(JSONString: (result?.result)!)
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
    
    func subscribeSnapshotV2(feedId: String) -> Void {
        print("enter subscribeSnapshotV2")
        #if !targetEnvironment(simulator)
        if(!SCMLongConnectManager.shared().isConnecting()) {
            return
        }
        SCMLongConnectManager.shared().subscribeShopShotFeedId(
            feedId,
            success: { (data) in
                print(data)
            },
            fail: { (error) in
                printError(error)
            })
        #endif
        print("exit subscribeSnapshotV2")
    }
    
    func unsubscribeSnapshotV2(feedId: String) -> Void {
        print("enter unsubscribeSnapshotV2")
        #if !targetEnvironment(simulator)
        SCMLongConnectManager.shared().cancelSubscriptionFeedId(
            feedId,
            success: { (data) in
                print("Cancel Subscriptions Successfully")
                print(data)
            },
            fail: { (error) in
                printError(error)
            })
        #endif
        print("exit unsubscribeSnapshotV2")
    }
    
    func getDeviceH5V2(feedId: String) -> Observable<JdDeviceUrl?> {
        print("enter getDeviceH5V2")
        return Observable<JdDeviceUrl?>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMCloudControlManager.getDeviceUrl(
                withVersion: ProductVersion.two.verVal,
                feedId: feedId,
                puid: nil,
                service: nil,
                success: { (data) in
                    let res = data as! [String: Any]
                    let result = Mapper<JdCloudResult>().map(JSON: res)
                    guard result?.status == 0 else {
                        printError(result?.error)
                        observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                        return
                    }
                    let deviceUrl = Mapper<JdDeviceUrl>().map(JSONString: (result?.result)!)
                    observer.onNext(deviceUrl)
                    observer.onCompleted()
                    print("exit getDeviceH5V2")
                }) { (error) in
                    printError(error)
                    observer.onError(error!)
                }
            #endif
            return Disposables.create()
        }
    }
    
    func getScenes(page: Int = 1, pageSize: Int = 30) -> Observable<SceneCollection?> {
        print("enter getScenes")
        return Observable<SceneCollection?>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMIFTTTManager.getIFTTTList(page, pageSize: pageSize, extend: nil) { (dict) in
                let res = dict as! [String: Any]
                let result = Mapper<JdCloudStructureResult<SceneCollection>>().map(JSON: res)
                guard result?.status == 0 else {
                    printError(result?.error)
                    observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                    return
                }
                observer.onNext(result?.result)
                observer.onCompleted()
                print("exit getScenes")
            }
            #endif
            return Disposables.create()
        }
    }
    
    func getDevicesOfScene(scriptId: String, logicId: String) -> Void {
        print("enter getDevicesOfScene")
        #if !targetEnvironment(simulator)
        SCMIFTTTManager.getIFTTTDevices(scriptId, logicId: logicId, extend: nil) { (result) in
            print(result)
        }
        #endif
    }
    
    func getDevicesWithSceneSupport(type: SceneSectionType) -> Observable<[JdDeviceWithSceneSupport]> {
        print("enter getDevicesOfScene")
        return Observable<[JdDeviceWithSceneSupport]>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMIFTTTManager.getIFTTTDeviceList(type.rawValue, extend: nil) { (dict) in
                let res = dict as! [String: Any]
                let result = Mapper<JdCloudStructureResult<JdDeviceWithSceneSupportCollection>>().map(JSON: res)
                guard result?.status == 0 else {
                    printError(result?.error)
                    observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                    return
                }
                let data = result?.result?.list ?? []
                observer.onNext(data)
                observer.onCompleted()
                print("exit getDevicesOfScene")
            }
            #endif
            return Disposables.create()
        }
    }
    
    func getProductInfo(productUUID: String, qrCode: String) -> Observable<JdProductInfo> {
        print("enter getProductInfo")
        return Observable<JdProductInfo>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMCloudActivateManager.getProductInfo(withPuid: productUUID, qrString: qrCode, success: { (dict) in
                let res = dict as! [String: Any]
                let result = Mapper<JdCloudStructureResult<JdProductInfo>>().map(JSON: res)
                guard result?.status == 0 else {
                    printError(result?.error)
                    observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                    return
                }
                let data = result?.result
                data?.uuid = productUUID
                observer.onNext(data!)
                observer.onCompleted()
            }) { (error) in
                printError(error)
                observer.onError(error!)
            }
            #endif
            return Disposables.create()
        }
    }
    
    func getProductDescV2(productUUID: String, configType: Int) -> Observable<JdProductDesc> {
        print("enter getProductInfo")
        return Observable<JdProductDesc>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMCloudActivateManager.getProductDesc(withVersion: "2.0", puid: productUUID, success: { (dict) in
                let res = dict as! [String: Any]
                let result = Mapper<JdCloudResult>().map(JSON: res)
                guard result?.status == 0 else {
                    printError(result?.error)
                    observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                    return
                }
                let data = Mapper<JdProductDesc>().map(JSONString: (result?.result)!)
                observer.onNext(data!)
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
