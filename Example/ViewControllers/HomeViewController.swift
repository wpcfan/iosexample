//
//  HomeViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/30.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import FSPagerView
import AlamofireImage
import RxSwift
import RxCocoa
import QRCodeReader
import AVFoundation

class HomeViewController: UIViewController {
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    private lazy var reader: QRCodeReader = QRCodeReader()
    private lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
//            $0.showSwitchCameraButton = false
            $0.showTorchButton = false
            $0.showCancelButton = false
            $0.preferredStatusBarStyle = .lightContent
            $0.cancelButtonTitle = NSLocalizedString("home.qrscanner.cancelbtn.title", comment: "")
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    private let viewModel = HomeViewModel()
    
    @IBOutlet var tableView: UITableView? {
        didSet {
            tableView?.delegate = viewModel
            tableView?.dataSource = viewModel
            tableView?.register(BannerCell.nib, forCellReuseIdentifier: BannerCell.identifier)
            tableView?.register(ChannelCell.nib, forCellReuseIdentifier: ChannelCell.identifier)
//            tableView?.register(SceneCell.nib, forCellReuseIdentifier: SceneCell.identifier)
            tableView?.configRefreshHeader(
                with: TableViewUtils.createHeader(),
                container: self,
                action: {
                    log.debug("add refresh header to table view")
                    self.tableView?.reloadData()
                    self.tableView?.switchRefreshHeader(to: .normal(.success, 0.3))
            })
        }
    }
    
    @IBAction public func scanInModalAction() {
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
}

extension HomeViewController: QRCodeReaderViewControllerDelegate {
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
}
