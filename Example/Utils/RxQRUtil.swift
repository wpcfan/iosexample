//
//  RxQRUtil.swift
//  Example
//
//  Created by 王芃 on 2018/11/4.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit
import RxQRScanner

struct RxQRUtil {
    
    public func scanQR(_ vc: BaseViewController) {
        var config = QRScanConfig.instance
        config.titleText = NSLocalizedString("qrscanner.navigation.title", comment: "")
        config.albumText = NSLocalizedString("qrscanner.navigation.right.title", comment: "")
        config.cancelText = NSLocalizedString("qrscanner.navigation.left.title", comment: "")
        Permission.checkCameraAccess()
            .filter { (hasAccess) -> Bool in hasAccess }
            .flatMap{ _ in QRScanner.popup(on: vc, config: config) }
            .map({ (result) -> String? in
                if case let .success(str) = result { return str }
                return nil
            })
            .take(1)
            .subscribe(onNext: { result in
                if (result != nil) {
                    print(result!)
                }
            })
            .disposed(by: vc.disposeBag)
    }
}
