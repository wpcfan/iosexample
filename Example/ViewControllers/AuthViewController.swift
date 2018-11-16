//
//  ViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import ReactorKit

class AuthViewController: BaseViewController {

    @objc weak var loginButton: UIButton!
    @objc weak var registerButton: UIButton!
    @objc weak var usernameField: UITextField!
    @objc weak var passwordField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
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
    }
}

extension AuthViewController: LayoutLoading {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadLayout(named: "AuthViewController.xml" )
    }
    
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = AuthViewControllerReactor()
    }
}
