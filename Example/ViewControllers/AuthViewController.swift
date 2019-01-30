//
//  ViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import ReactorKit
import RxSwift
import Toast_Swift
import RxKeyboard
import RxOptional

class AuthViewController: BaseViewController {
    
    @objc weak var loginButton: UIButton!
    @objc weak var registerButton: UIButton!
    @objc weak var usernameField: UITextField!
    @objc weak var passwordField: UITextField!
    @objc weak var scrollView: UIScrollView!
    var pwdVisible: Bool = false {
        didSet {
            self.layoutNode!.setState(["pwdVisible": !pwdVisible])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.presentTransparentNavigationBar(light: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLayout(
            named: "AuthViewController.xml",
            state: [
                "loading": false,
                "validation": false,
                "pwdVisible": false,
                "app": AppIcons.app,
                ],
            constants: [
                "loginFormValid": { (args: [Any]) throws -> Any in
                    guard let loading = args.first as? Bool, let validation = args[1] as? Bool else {
                        throw LayoutError.message("loginFormValid() function expects a pair of Bool argument")
                    }
                    return !loading && validation
                },
                "eye": AppIcons.eye,
                "eyeOff": AppIcons.eyeOff,
                "clear": AppIcons.clear
                ]
        )
        usernameField.setBottomBorder(withColor: .lightGray)
        passwordField.setBottomBorder(withColor: .lightGray)
        TextFieldResponder.shared.addResponders([usernameField, passwordField])
    }
    
    @objc func register() -> Void {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc func togglePwdVisible() -> Void {
        self.pwdVisible = !self.pwdVisible
    }
}

extension AuthViewController: View {
    typealias Reactor = AuthViewControllerReactor
    
    func bind(reactor: Reactor) {
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [scrollView] keyboardVisibleHeight in
                scrollView!.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: self.disposeBag)
        
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
                guard let err = ev.element else { return }
                self.view?.makeToast(err)
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.loading }
            .bind(to: self.layoutNode!.rx.state("loading"))
            .disposed(by: self.disposeBag)
    }
}

extension AuthViewController: LayoutLoading {
    
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = AuthViewControllerReactor()
    }
}
