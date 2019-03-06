//
//  RxQRUtil.swift
//  Example
//
//  Created by 王芃 on 2018/11/4.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit
import RxQRScanner
import RxSwift
import URLNavigator

struct JDQRResult {
    var productUUID: String?
    var deviceId: String?
    var deviceMac: String?
    var deviceType: String?
    var token: String?
    var originQRCode: URLConvertible?
}

struct RxQRUtil {
    
    public func scanQR(_ vc: UIViewController) -> Observable<String?> {
        weak var sourceVC: UIViewController! = vc
        var config = QRScanConfig.instance
        config.titleText = "qrscanner.navigation.title".localized
        config.albumText = "qrscanner.navigation.right.title".localized
        config.cancelText = "qrscanner.navigation.left.title".localized
        return Permission.checkCameraAccess()
            .filter { (hasAccess) -> Bool in hasAccess }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .flatMapFirst{ _ in QRScanner.popup(on: sourceVC, config: config) }
            .map({ (result) -> String? in
                if case let .success(str) = result { return str }
                return nil
            })
    }
    
    public func parseJdQR(qrCode: URLConvertible) -> JDQRResult? {
        guard qrCode.urlValue != nil, qrCode.urlStringValue.contains("smart.jd.com/download?") else { return nil }
        let params = qrCode.queryParameters
        let uuidEndIndex = 6
        let uuIdStartIndex = 0
        for key in params.keys {
            guard let paramVal = params[key]?.base64Decoded() else { return nil }
            switch key {
            case "a", "c":
                guard paramVal.count >= uuidEndIndex else { return nil }
                return JDQRResult(
                    productUUID: paramVal[uuIdStartIndex..<uuidEndIndex],
                    deviceId: nil,
                    deviceMac: nil,
                    deviceType: paramVal[uuidEndIndex..<paramVal.count],
                    token: nil,
                    originQRCode: qrCode)
            case "b", "d":
                guard paramVal.count >= uuidEndIndex else { return nil }
                return JDQRResult(
                    productUUID: paramVal[uuIdStartIndex..<uuidEndIndex],
                    deviceId: nil,
                    deviceMac: nil,
                    deviceType: "-1",
                    token: nil,
                    originQRCode: qrCode)
            case "e": // 蓝牙设备跳转到蓝牙相关界面
                return nil
            case "f":
                guard paramVal.count >= 38 else { return nil }
                var paramValue = paramVal
                if let range = paramVal.range(of: "$$$") { // 海康摄像头
                    paramValue = String(paramVal[..<range.lowerBound])
                }
                return JDQRResult(
                    productUUID: paramValue[uuIdStartIndex..<uuidEndIndex],
                    deviceId: paramValue[38..<paramValue.count],
                    deviceMac: nil,
                    deviceType: nil,
                    token: paramValue[uuidEndIndex..<32],
                    originQRCode: qrCode)
            case "g": // 网关子设备
                guard paramVal.count >= uuidEndIndex else { return nil }
                return JDQRResult(
                    productUUID: paramVal[uuIdStartIndex..<uuidEndIndex],
                    deviceId: nil,
                    deviceMac: paramVal[uuidEndIndex..<paramVal.count],
                    deviceType: nil,
                    token: nil,
                    originQRCode: qrCode)
            case "y":
                guard paramVal.count >= uuidEndIndex else { return nil }
                return JDQRResult(
                    productUUID: paramVal[uuIdStartIndex..<uuidEndIndex],
                    deviceId: paramVal[uuidEndIndex..<paramVal.count],
                    deviceMac: nil,
                    deviceType: nil,
                    token: nil,
                    originQRCode: qrCode)
            default:
                return nil
            }
        }
        return nil
    }
}
