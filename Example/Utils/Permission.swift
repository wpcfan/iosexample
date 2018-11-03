//
//  Permission.swift
//  Example
//
//  Created by 王芃 on 2018/10/19.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import AVFoundation
import RxSwift

struct Permission {
    static func checkCameraAccess() -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                printError("Denied, request permission from settings")
                observer.onNext(false)
                observer.onCompleted()
            case .restricted:
                printError("Restricted, device owner must approve")
                observer.onNext(false)
                observer.onCompleted()
            case .authorized:
                print("Authorized, proceed")
                observer.onNext(true)
                observer.onCompleted()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success {
                        print("Permission granted, proceed")
                        observer.onNext(true)
                        observer.onCompleted()
                    } else {
                        printError("Permission denied")
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        })
        
    }

}
