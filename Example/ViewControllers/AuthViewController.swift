//
//  ViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import URLNavigator
import PMAlertController
import RxSwift

class AuthViewController: UIViewController, LayoutLoading {
    
    private let oauth2Service = container.resolve(OAuth2Service.self)!
    
    @IBOutlet private weak var authAutoButton: UIButton!
    @IBOutlet private weak var userinfoButton: UIButton!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var trashButton: UIBarButtonItem!
    private var disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadLayout(named: "AuthViewController.xml" )
    }
    
    @objc func doAuth() -> Void {
        self.oauth2Service.login(
            username: self.usernameField.text!,
            password: self.passwordField.text!)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe{ event -> Void in
                switch event {
                case .error(let error):
                    log.error(error.localizedDescription)
                    break
                case .next(_):
                    AppDelegate.shared.rootViewController.switchToMainScreen()
                    break
                case .completed:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    @objc func displayInfo() -> Void {
        self.present(HomeTabViewController(tabName: "app"), animated: true, completion: nil)
        
    }
}
