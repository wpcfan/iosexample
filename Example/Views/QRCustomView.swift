//
//  QRCustomView.swift
//  Example
//
//  Created by 王芃 on 2018/10/10.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import QRCodeReader
import SnapKit
import SwiftIconFont

class QRCustomView: UIView, QRCodeReaderDisplayable {
    let qrScreenView: UIStackView = UIStackView()
    let toolbarView: UIStackView = UIStackView()
    private weak var reader: QRCodeReader?
    public lazy var cancelButton: UIButton? = {
        let cb = UIButton()
        
        cb.translatesAutoresizingMaskIntoConstraints = false
        cb.titleLabel?.font = UIFont.icon(from: .ionicon, ofSize: 48)
        cb.setTitle("arrow-round-back", for: .normal)
        cb.setTitleColor(UIColor.white, for: .normal)
        
        return cb
    }()
    
    public lazy var switchCameraButton: UIButton? = {
        let scb = SwitchCameraButton()
        
        scb.translatesAutoresizingMaskIntoConstraints = false
        scb.titleLabel?.font = UIFont.icon(from: .ionicon, ofSize: 48)
        scb.setTitle("camera", for: .normal)
        scb.setTitleColor(UIColor.white, for: .normal)
        return scb
    }()
    
    public lazy var toggleTorchButton: UIButton? = {
        let ttb = ToggleTorchButton()
        
        ttb.translatesAutoresizingMaskIntoConstraints = false
        ttb.titleLabel?.font = UIFont.icon(from: .ionicon, ofSize: 48)
        ttb.setTitle("flash", for: .normal)
        ttb.setTitleColor(UIColor.white, for: .normal)
        return ttb
    }()
    
    public let cameraView: UIView = {
        let cv = UIView()
        
        cv.clipsToBounds                             = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    public lazy var overlayView: UIView? = {
        let ov = ReaderOverlayView()
        
        ov.backgroundColor                           = .clear
        ov.clipsToBounds                             = true
        ov.translatesAutoresizingMaskIntoConstraints = false
    
        return ov
    }()
    
    @objc public func setNeedsUpdateOrientation() {
        setNeedsDisplay()
        
        overlayView?.setNeedsDisplay()
        
        if let connection = reader?.previewLayer.connection, connection.isVideoOrientationSupported {
            let application                    = UIApplication.shared
            let orientation                    = UIDevice.current.orientation
            let supportedInterfaceOrientations = application.supportedInterfaceOrientations(for: application.keyWindow)
            
            connection.videoOrientation = QRCodeReader.videoOrientation(deviceOrientation: orientation, withSupportedOrientations: supportedInterfaceOrientations, fallbackOrientation: connection.videoOrientation)
        }
    }

    
    func setupComponents(showCancelButton: Bool, showSwitchCameraButton: Bool, showTorchButton: Bool, showOverlayView: Bool, reader: QRCodeReader?) {
        self.addSubview(qrScreenView)
        qrScreenView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        qrScreenView.axis = .vertical
        qrScreenView.addSubview(cameraView)
        qrScreenView.addSubview(toolbarView)
        
        toolbarView.spacing = 15
        toolbarView.axis = .horizontal
        
        if (showSwitchCameraButton) {
            toolbarView.addSubview(switchCameraButton!)
        }
        if (showTorchButton) {
            toolbarView.addSubview(toggleTorchButton!)
        }
        if (showCancelButton) {
            toolbarView.addSubview(cancelButton!)
        }
        
        toolbarView.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.height.equalTo(60)
        }
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        reader?.previewLayer.frame = bounds
    }
}

