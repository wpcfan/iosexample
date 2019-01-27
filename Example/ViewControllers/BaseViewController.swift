//
//  BaseViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/17.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

import RxSwift
import Shallows

class BaseViewController: UIViewController {
    // MARK: Rx
    var disposeBag = DisposeBag()
    private let storage = container.resolve(Storage<Filename, AppData>.self)!
    private let registerService = container.resolve(RegisterService.self)!
    
    // MARK: Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsUpdateConstraints()
        self.handleGlobalRedirect()
    }
    
    func initialize() -> Void {
        
    }
    
    func handleGlobalRedirect() -> Void {
        // Handle Logout Globally
        needLogout
            .flatMapLatest({ (_) -> Observable<Bool> in
                return self.registerService.request()
                    .flatMapLatest({ (register: Register) -> Observable<Bool> in
                        let appData = AppData(JSON: ["tourGuidePresented": true, "token": register.token!])!
                        return self.storage.rx_set(value: appData, forKey: Filename(rawValue: Constants.APP_DATA_KEY))
                    })
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ _ in
                AppDelegate.shared.rootViewController.switchToLogout()
            }
            .disposed(by: self.disposeBag)
    }
}
