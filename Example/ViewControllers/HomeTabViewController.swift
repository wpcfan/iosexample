//
//  HomeViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/29.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import URLNavigator
import SwiftIconFont
import QRCodeReader
import AVFoundation

class MainNavigationController: UINavigationController { }

class HomeTabViewController: UIViewController, QRCodeReaderViewControllerDelegate, UITabBarControllerDelegate, LayoutLoading {
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = false
            $0.preferredStatusBarStyle = .lightContent
            $0.cancelButtonTitle = NSLocalizedString("home.qrscanner.cancelbtn.title", comment: "")
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    private var selectedTab = 0
    @IBOutlet var tabNode: UITabBarController? // outlet
    
    init(tabName: String) {
        super.init(nibName: nil, bundle: nil)
        if (tabName == "status") {
            selectedTab = 2
        } else if (tabName == "home") {
            selectedTab = 1
        } else {
            selectedTab = 0
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func applyNavigationStyle() {
        switch selectedTab {
        case 1:
            self.navigationItem.title = NSLocalizedString("main.navigation.status.title", comment: "")
            let button = UIButton(type: .custom)
            button.setImage(AppIcons.btnAdd, for: .normal)
            button.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 30, height: 30))
            button.addTarget(self, action: #selector(scanInModalAction(sender:)), for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: button)
            self.navigationItem.rightBarButtonItem = barButton
        case 2:
            self.navigationItem.title = NSLocalizedString("main.navigation.my.title", comment: "")
        default:
            self.navigationItem.title = NSLocalizedString("main.navigation.home.title", comment: "")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyNavigationStyle()
        
        loadLayout(
            named: "HomeTabViewController.xml",
            state: [
                "selectedTab": selectedTab
            ],
            constants: [
                "uppercased": AppLayoutClousures.upperCase,
                "iconTabHome": AppIcons.tabHome,
                "iconTabSocial": AppIcons.tabSocial,
                "iconTabMy": AppIcons.tabMy,
                "iconAdd": AppIcons.btnAdd
                ]
        )
    }
    func layoutDidLoad(_ layoutNode: LayoutNode) {
        guard let tabBarController = layoutNode.viewController as? UITabBarController else {
            return
        }
        
        tabBarController.selectedIndex = selectedTab
        tabBarController.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = tabBarController.viewControllers?.index(of: viewController) else {
            return
        }
        selectedTab = index
        applyNavigationStyle()
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    @IBAction public func scanInModalAction(sender: UIButton) {
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
}
