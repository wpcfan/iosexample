//
//  ViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import ReactorKit
import Shallows
import RxSwift
import Toast_Swift

class AuthViewController: BaseViewController {
    
    @objc weak var loginButton: UIButton!
    @objc weak var registerButton: UIButton!
    @objc weak var usernameField: UITextField!
    @objc weak var passwordField: UITextField!
    
    private let storage = container.resolve(Storage<Filename, AppData>.self)!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.title = NSLocalizedString("login.navigation.title", comment: "")
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = UIColor.primaryDark
    }
    
    @objc func register() -> Void {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}

extension AuthViewController: View {
    typealias Reactor = AuthViewControllerReactor
    
    func bind(reactor: Reactor) {
        loginButton.rx.tap
            .map{ Reactor.Action.login(
                username: (self.usernameField.text)!,
                password: (self.passwordField.text)!)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.errorMessage }
            .filter({ (msg) -> Bool in
                !msg.isBlank
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ ev in
                self.view?.makeToast(ev.element!)
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.loading }
            .bind(to: self.layoutNode!.rx.state("loading"))
            .disposed(by: self.disposeBag)
    }
}

extension AuthViewController: LayoutLoading {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadLayout(named: "AuthViewController.xml", state: ["loading": false])
    }
    
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = AuthViewControllerReactor()
    }
}
