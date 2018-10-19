//
//  ViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import ReactorKit

class AuthViewController: BaseViewController, LayoutLoading, StoryboardView {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadLayout(named: "AuthViewController.xml" )
    }
    
    @IBAction func register() -> Void {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = AuthViewReactor()
    }
    
    func bind(reactor: AuthViewReactor) {
        loginButton.rx.tap
            .map{ Reactor.Action.login(
                username: (self.usernameField.text)!,
                password: (self.passwordField.text)!)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}

