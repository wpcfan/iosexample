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

class DeviceWebViewController: WebKitViewController {
    var deviceUrl: SCDeviceUrl?
    private let scService = container.resolve(JdSmartCloudService.self)!
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
    
    override func initialize() {
        super.initialize()
        
        NotificationCenter.default.rx
            .notification(.SCMSocketLongConnectStatuChange)
            .map { (notification) -> SCM_LONG_CONNECT_STATUS in
                let status = notification.userInfo!["status"] as! Int
                print(status)
                switch(status) {
                case SCM_LONG_CONNECT_STATUS.CONNECTING.rawValue:
                    return SCM_LONG_CONNECT_STATUS.CONNECTING
                case SCM_LONG_CONNECT_STATUS.AUTH.rawValue:
                    return SCM_LONG_CONNECT_STATUS.AUTH
                case SCM_LONG_CONNECT_STATUS.AUTH_FAIL.rawValue:
                    return SCM_LONG_CONNECT_STATUS.AUTH_FAIL
                default:
                    return SCM_LONG_CONNECT_STATUS.CONNECT_FAIL
                }
            }
            .filter({ (status) -> Bool in
                status == SCM_LONG_CONNECT_STATUS.CONNECTING
            })
            .subscribe{
                self.subscribeSnapshotV2()
            }
            .disposed(by: disposeBag)
        
        scService.longConnectReceiveData()
            .subscribe{
                print($0.element)
            }
            .disposed(by: disposeBag)
    }
    
    @objc func showSettings() {
        
    }
    
    func subscribeSnapshotV2() {
        scService.subscribeSnapshotV2(feedId: String(deviceUrl!.device!.feedId!))
    }
}

extension DeviceWebViewController: SCMH5ControlManagerDelegate {
    
}
