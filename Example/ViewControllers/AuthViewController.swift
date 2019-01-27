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
        self.navigationController?.navigationBar.topItem?.title = "login.navigation.title".localized
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.textIcon!]
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = .primary
        
    }
    
    @objc func register() -> Void {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}

extension AuthViewController: View {
    typealias Reactor = AuthViewControllerReactor
    
    func bind(reactor: Reactor) {
        Observable.combineLatest([usernameField.rx.text, passwordField.rx.text])
            .map { (vals) -> Bool in
                let username = vals[0]!
                let password = vals[1]!
                return !username.isBlank && !password.isBlank
            }
            .bind(to: self.layoutNode!.rx.state("validation"))
            .disposed(by: self.disposeBag)
        
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
        self.loadLayout(
            named: "AuthViewController.xml",
            state: [
                "loading": false,
                "validation": false,
                "app": AppIcons.app,
                ],
            constants: [
                "loginFormValid": { (args: [Any]) throws -> Any in
                    guard let loading = args.first as? Bool, let validation = args[1] as? Bool else {
                        throw LayoutError.message("loginFormValid() function expects a pair of Bool argument")
                    }
                    return !loading && validation
                },
                ]
            )
    }
    
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = AuthViewControllerReactor()
    }
}
