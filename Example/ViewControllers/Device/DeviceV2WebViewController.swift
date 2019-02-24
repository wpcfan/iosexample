//
//  DeviceWebViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/17.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import Layout
import RxSwift
import RxCocoa
import NotificationBannerSwift

class DeviceV2WebViewController: UIWebViewController {
    var deviceUrl: SCDeviceUrl?
    private let scService = container.resolve(JdSmartCloudService.self)!
    #if !targetEnvironment(simulator)
    private var dataManager: SCMControlDataManager?
    private var h5Manager: SCMH5ControlManager?
    #endif
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subscribeSnapshotV2()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        buildBarRightButton()
    }
    
    private func buildBarRightButton() {
        let deviceSettingButtonItem = buildButtonItem(icon: AppIcons.settingsWhite, action: #selector(showSettings))
        self.navigationItem.rightBarButtonItem = deviceSettingButtonItem
    }
    
    @objc func showSettings() {
        
    }
    
    func subscribeSnapshotV2() {
        scService.subscribeSnapshotV2(feedId: String(deviceUrl!.device!.feedId!))
    }
    
    override func layoutDidLoad(_ layoutNode: LayoutNode) {
        super.layoutDidLoad(layoutNode)
        
        weak var `self`: DeviceV2WebViewController! = self
        #if !targetEnvironment(simulator)
        dataManager = SCMControlDataManager(feedId: String(deviceUrl!.device!.feedId!), service: nil, puid: deviceUrl?.product?.productUUID, delegate: self)
        h5Manager = SCMH5ControlManager(feedId: String(deviceUrl!.device!.feedId!), service: nil, puid: deviceUrl?.product?.productUUID, version: "2.0", srcType: .wan, webViewDelegate: self, webView: self.webView)
        NotificationCenter.default.rx
            .notification(.SCMSocketLongConnectDidReceivedData)
            .takeUntil(self.rx.viewWillDisappear)
            .subscribe { ev in
                guard let notification = ev.element else { return }
                print(notification.userInfo)
                self.h5Manager?.handleSnapshot(withWebView: self.webView, dataDictionary: notification.userInfo)
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.SCMSocketLongConnectStatuChange)
            .takeUntil(self.rx.viewWillDisappear)
            .subscribe{ ev in
                guard let notification = ev.element else { return }
                let status = notification.userInfo!["status"] as! Int
                print(status)
                switch(status) {
                case SCM_LONG_CONNECT_STATUS.CONNECTING.rawValue:
                    self.subscribeSnapshotV2()
                    let notificationBanner = NotificationBanner(title: "长连接已建立", subtitle: "可以正常使用", style: .success)
                    notificationBanner.show()
                    return
                case SCM_LONG_CONNECT_STATUS.AUTH.rawValue:
                    let notificationBanner = NotificationBanner(title: "长连接正在认证", subtitle: "请稍侯", style: .info)
                    notificationBanner.show()
                    return
                case SCM_LONG_CONNECT_STATUS.AUTH_FAIL.rawValue:
                    let notificationBanner = NotificationBanner(title: "长连接认证失败", subtitle: "网络环境较差，请检查网络设置", style: .warning)
                    notificationBanner.show()
                    return
                default:
                    let notificationBanner = NotificationBanner(title: "长连接失败", subtitle: "网络环境较差，请检查网络设置", style: .warning)
                    notificationBanner.show()
                    return
                }
            }
            .disposed(by: disposeBag)
        
        self.rx.viewWillDisappear
            .subscribe { _ in
                self.webView.stopLoading()
                self.scService.unsubscribeSnapshotV2(feedId: String(self.deviceUrl!.device!.feedId!))
                guard let bridge = self.h5Manager?.getBridge() else { return }
                bridge.disconnectWithWebView()
            }
            .disposed(by: disposeBag)
        #endif
    }
}

#if !targetEnvironment(simulator)
extension DeviceV2WebViewController: SCMH5ControlManagerDelegate {
    func deviceH5BridgeReadyConfigAction(_ configDic: [AnyHashable : Any]!) {
        print("deviceH5BridgeReadyConfigAction")
        print(configDic)
    }
    
    func openH5Url(withDataAction data: Any!) {
        print("openH5Url")
        print(data)
    }
    
    func refreshOnlineViewAction(_ status: String!) {
        print("refreshOnlineViewAction")
        print(status)
    }
    
    func toSubDeviceListAction() {
        
    }
    
    func jumpSubDeviceAction(_ data: Any!) {
        print("jumpSubDeviceAction")
        print(data)
    }
    
    func configActionBarAction(_ data: Any!) {
        print("configActionBarAction")
        print(data)
    }
    
    func closeWindowAction() {
        print("closeWindowAction")
    }
    
    func jump(toNativePageAction data: Any!) {}
    
    func showShareViewAction(_ data: Any!) {
        
    }
    
    func errorTipAction(_ msg: String!) {
        
    }
    
    func openUrlOrVCAction(_ data: Any!) {
        print("openUrlOrVCAction")
        print(data)
    }
    
    func setNavigationBarTitleAction(_ data: Any!) {
        print("setNavigationBarTitleAction")
        print(data)
    }
    
    func showAlert(withDataAction data: Any!, callBack callback: ((Bool) -> Void)!) {
        print("showAlert")
        print(data)
    }
}
#endif

#if !targetEnvironment(simulator)
extension DeviceV2WebViewController: SCMControlDeviceDataDelegate {
    func deviceInfoDictionary(_ deviceInfoDictionary: [AnyHashable : Any]!) {
        
    }
    
    func h5Url(_ url: String!) {
        
    }
}
#endif