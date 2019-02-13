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

struct RxQRUtil {
    
    public func scanQR(_ vc: UIViewController) -> Observable<String?> {
        var config = QRScanConfig.instance
        config.titleText = "qrscanner.navigation.title".localized
        config.albumText = "qrscanner.navigation.right.title".localized
        config.cancelText = "qrscanner.navigation.left.title".localized
        return Permission.checkCameraAccess()
            .filter { (hasAccess) -> Bool in hasAccess }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .flatMap{ _ in QRScanner.popup(on: vc, config: config) }
            .map({ (result) -> String? in
                if case let .success(str) = result { return str }
                return nil
            })
    }
}
