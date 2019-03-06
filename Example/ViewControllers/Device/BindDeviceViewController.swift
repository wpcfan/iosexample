//
//  BindDeviceViewController.swift
//  Example
//
//  Created by 王芃 on 2019/3/6.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import NVActivityIndicatorView

struct WifiInfo {
    var ssid: String?
    var password: String?
}

class BindDeviceViewController: BaseViewController, LayoutLoading {
    private let productInfo: JdProductInfo
    private let wifiInfo: WifiInfo
    private let scServie = container.resolve(JdSmartCloudService.self)!
    @objc weak var activityIndicatorView: NVActivityIndicatorView!
    init(productInfo: JdProductInfo, wifiInfo: WifiInfo) {
        self.productInfo = productInfo
        self.wifiInfo = wifiInfo
        super.init()
    }
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "bindDevice.title".localized
        loadLayout(named: "BindDeviceViewController.xml",
                   state: [
                    "imageUrl": "",
                    "deviceName": ""
                    ])
    }
    func layoutDidLoad(_: LayoutNode) {
        
        weak var `self`: BindDeviceViewController! = self
        if !activityIndicatorView.isAnimating {
            activityIndicatorView.startAnimating()
        }
        scServie.startNetConfig(productInfo: productInfo, wifiInfo: wifiInfo, countDown: 60)
            .filterNil()
            .subscribe(onNext: { (device) in
                self.layoutNode?.setState([
                    "deviceName": device.deviceName,
                    ])
            }, onError: { (error) in
                self.view.makeToast(convertErrorToString(error: error))
            }, onCompleted: {
                if(self.activityIndicatorView.isAnimating) {
                    self.activityIndicatorView.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
}
