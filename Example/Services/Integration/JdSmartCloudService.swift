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
    
    func getProductInfo(productUUID: String, qrResult: JDQRResult) -> Observable<JdProductInfo> {
        print("enter getProductInfo")
        return Observable<JdProductInfo>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            let qrCode = qrResult.originQRCode?.urlStringValue
            SCMCloudActivateManager.getProductInfo(
                withPuid: productUUID,
                qrString: qrCode,
                success: { (dict) in
                let res = dict as! [String: Any]
                let result = Mapper<JdCloudStructureResult<JdProductInfo>>().map(JSON: res)
                guard result?.status == 0 else {
                    printError(result?.error)
                    observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                    return
                }
                let data = result?.result
                data?.uuid = productUUID
                data?.qrCode = qrCode
                data?.deviceMac =  qrResult.deviceMac
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
    
    func startNativeConfig(productInfo: JdProductInfo, wifiInfo: WifiInfo) -> Observable<SCMLanDeviceModel?> {
        let model = SCMOneStepNativeModel()
        model.puid = productInfo.uuid
        model.qrCode = productInfo.qrCode
        model.ssid = wifiInfo.ssid
        model.pwd = wifiInfo.password
        return Observable<SCMLanDeviceModel?>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMConfigNetManager.startOneStepConfigNative(model, result: { (arrDevices) in
                guard let devices = arrDevices as? [SCMLanDeviceModel], devices.count > 0 else {
                    observer.onNext(nil)
                    return
                }
                if let lanDeviceModel = devices.first(where: { (deviceModel) -> Bool in
                    deviceModel.puid == model.puid
                }) {
                    self.stopNativeConfig()
                    lanDeviceModel.deviceName = productInfo.name
                    observer.onNext(lanDeviceModel)
                    observer.onCompleted()
                }
                
            }) { (error) in
                self.stopNativeConfig()
                printError(error)
                let err = Mapper<JdNetConfigResult>().map(JSON: error as! [String: Any])
                observer.onError(SCError.NetConfigError(err?.result?.status, err?.result?.message))
            }
            #endif
            return Disposables.create()
        }
        
    }
    
    func startCloudConfig(productInfo: JdProductInfo, wifiInfo: WifiInfo) -> Observable<SCMLanDeviceModel?> {
        let model = SCMOneStepCloudModel()
        model.configType = productInfo.configType!
        model.deviceName = productInfo.name
        model.puid = productInfo.uuid
        model.macID = productInfo.deviceMac
        model.ssid = wifiInfo.ssid
        model.pwd = wifiInfo.password
        return Observable<SCMLanDeviceModel?>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMConfigNetManager.startOneStepConfigCloud(model, result: { (arrDevices) in
                guard let devices = arrDevices as? [SCMLanDeviceModel], devices.count > 0 else {
                    observer.onNext(nil)
                    return
                }
                if let lanDeviceModel = devices.first(where: { (deviceModel) -> Bool in
                    deviceModel.puid == model.puid
                }) {
                    self.stopCloudConfig()
                    lanDeviceModel.deviceName = productInfo.name
                    observer.onNext(lanDeviceModel)
                    observer.onCompleted()
                }
                
            }) { (error) in
                self.stopCloudConfig()
                printError(error)
                let err = Mapper<JdNetConfigResult>().map(JSON: error as! [String: Any])
                observer.onError(SCError.NetConfigError(err?.result?.status, err?.result?.message))
            }
            #endif
            return Disposables.create()
        }
    }
    
    func startThridPartyConfig(productInfo: JdProductInfo, wifiInfo: WifiInfo) -> Observable<SCMLanDeviceModel?> {
        
        let model = SCMThirdConfigModel()
        model.puid = productInfo.uuid
        model.configType = productInfo.configType!
        model.protocol_version = productInfo.protocolVersion
        model.ssid = wifiInfo.ssid
        model.pwd = wifiInfo.password
        return Observable<SCMLanDeviceModel?>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMConfigNetManager.startThirdConfig(model, result: { (arrDevices) in
                guard let devices = arrDevices as? [SCMLanDeviceModel], devices.count > 0 else {
                    observer.onNext(nil)
                    return
                }
                if let lanDeviceModel = devices.first(where: { (deviceModel) -> Bool in
                    deviceModel.puid == model.puid
                }) {
                    self.stopThirdPartyConfig()
                    lanDeviceModel.deviceName = productInfo.name
                    observer.onNext(lanDeviceModel)
                    observer.onCompleted()
                }
                
            }) { (error) in
                self.stopThirdPartyConfig()
                printError(error)
                let err = Mapper<JdNetConfigResult>().map(JSON: error as! [String: Any])
                observer.onError(SCError.NetConfigError(err?.result?.status, err?.result?.message))
            }
            #endif
            return Disposables.create()
        }
    }
    
    func startSoftApConfig(productInfo: JdProductInfo, wifiInfo: WifiInfo) -> Observable<SCMLanDeviceModel?> {
        let model = SCMSoftApModel()
        model.puid = productInfo.uuid
        model.ssid = wifiInfo.ssid
        model.pwd = wifiInfo.password
        return Observable<SCMLanDeviceModel?>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMConfigNetManager.startSoftApConfig(model, result: { (arrDevices) in
                guard let devices = arrDevices as? [SCMLanDeviceModel], devices.count > 0 else {
                    observer.onNext(nil)
                    return
                }
                if let lanDeviceModel = devices.first(where: { (deviceModel) -> Bool in
                    deviceModel.puid == model.puid
                }) {
                    self.stopSoftApConfig()
                    lanDeviceModel.deviceName = productInfo.name
                    observer.onNext(lanDeviceModel)
                    observer.onCompleted()
                }
                
            }) { (error) in
                self.stopSoftApConfig()
                printError(error)
                let err = Mapper<JdNetConfigResult>().map(JSON: error as! [String: Any])
                observer.onError(SCError.NetConfigError(err?.result?.status, err?.result?.message))
            }
            #endif
            return Disposables.create()
        }
    }
    
    func scanDevices() -> Void {
        #if !targetEnvironment(simulator)
        SCMScanDeviceManager.scanDevice()
        #endif
    }
    
    func scanDevice(productUUID: String) -> Void {
        #if !targetEnvironment(simulator)
        SCMScanDeviceManager.scanDevice(withPuid: productUUID)
        #endif
    }
    
    func scanSubDevices(productUUID: String) -> Void {
        #if !targetEnvironment(simulator)
        SCMScanDeviceManager.scanSubDevice(withPuid: productUUID)
        #endif
    }
    
    func stopNativeConfig() -> Void {
        #if !targetEnvironment(simulator)
        SCMConfigNetManager.stopOneStepConfigNative()
        #endif
    }
    
    func stopCloudConfig() -> Void {
        #if !targetEnvironment(simulator)
        SCMConfigNetManager.stopOneStepConfigCloud()
        #endif
    }
    
    func stopSoftApConfig() -> Void {
        #if !targetEnvironment(simulator)
        SCMConfigNetManager.stopSoftApConfig()
        #endif
    }
    
    func stopThirdPartyConfig() -> Void {
        #if !targetEnvironment(simulator)
        SCMConfigNetManager.stopThirdConfig()
        #endif
    }
    
    func activateDeviceV2(model: SCMLanDeviceModel) -> Observable<JdActivateResult?> {
        return Observable<JdActivateResult?>.create{ (observer) -> Disposable in
            #if !targetEnvironment(simulator)
            SCMCloudActivateManager.activateV2Device(model, result: { (dict) in
                let res = dict as! [String: Any]
                let result = Mapper<JdCloudStructureResult<JdActivateResult>>().map(JSON: res)
                guard result?.status == 0 else {
                    printError(result?.error)
                    observer.onError(SCError.JdSmartError(result?.error?.errorCode, result?.error?.errorInfo, result?.error?.debugMe))
                    return
                }
                observer.onNext(result?.result)
                observer.onCompleted()
            }) { (error) in
                printError(error)
                let err = Mapper<JdNetConfigResult>().map(JSON: error as! [String: Any])
                observer.onError(SCError.NetConfigError(err?.result?.status, err?.result?.message))
            }
            #endif
            return Disposables.create()
        }
    }
    
    func startNetConfig(productInfo: JdProductInfo, wifiInfo: WifiInfo, countDown: Int) -> Observable<SCMLanDeviceModel?> {
        switch productInfo.configType! {
        case 1001, 1002, 1003:
            return startThridPartyConfig(productInfo: productInfo, wifiInfo: wifiInfo)
                .timeout(RxTimeInterval(countDown), scheduler: MainScheduler.instance)
        case 1113: // 本地一键配置
            return startNativeConfig(productInfo: productInfo, wifiInfo: wifiInfo)
                .timeout(RxTimeInterval(countDown), scheduler: MainScheduler.instance)
        case 1114: // Soft AP
            return startSoftApConfig(productInfo: productInfo, wifiInfo: wifiInfo)
                .timeout(RxTimeInterval(countDown), scheduler: MainScheduler.instance)
//        case 1115: // 本地配网 + Soft AP
//        case 1903: // 已入网设备，直接进行设备扫描
//            scanDevices(productUUID: productInfo.uuid!)
//            return
        default:
            return startCloudConfig(productInfo: productInfo, wifiInfo: wifiInfo)
                .timeout(RxTimeInterval(countDown), scheduler: MainScheduler.instance)
        }
    }
    
    private func handleDeviceScanned(dict: [SCMLanDeviceModel]) {
        
    }
}
