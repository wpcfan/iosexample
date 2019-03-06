//
//  AddDeviceViewController.swift
//  Example
//
//  Created by 王芃 on 2019/3/6.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout

class AddDeviceViewController: BaseViewController, LayoutLoading {
    private let htmlHeader = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header>"
    private let scService = container.resolve(JdSmartCloudService.self)!
    private let productInfo: JdProductInfo
    @objc weak var webView: WKWebView!
    init(productInfo: JdProductInfo) {
        self.productInfo = productInfo
        super.init()
    }
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "addDevice.title".localized
        loadLayout(named: "AddDeviceViewController.xml",
                   state: [
                    "imageUrl": productInfo.imageUrl ?? "",
                    "deviceName": productInfo.name ?? "",
                    "wifiSSID": UIDevice().WiFiSSID ?? ""
                    ],
                   constants: [
                    "rightArrow": AppIcons.rightArrow
                    ])
    }
    func layoutDidLoad(_: LayoutNode) {
        weak var `self`: AddDeviceViewController! = self
        scService.getProductDescV2(productUUID: productInfo.uuid!, configType: productInfo.configType!)
            .subscribe { ev in
                guard let prodInfo = ev.element else { return }
                var renderString: String
                switch self.productInfo.configType {
                case 1001, 1002, 1003:
                    renderString = prodInfo.content ?? ""
                    break
                default:
                    renderString = prodInfo.oneKeyConfigDescArr!
                        .map { config in config.detail ?? "" }
                        .joined(separator: "<br>")
                }
                self.webView.loadHTMLString("\(self.htmlHeader)\(renderString)", baseURL: nil)
            }
            .disposed(by: self.disposeBag)
    }
    @objc func openAppSetting() -> Void {
        
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsURL) else {  return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(settingsURL)
        }
    }
}
