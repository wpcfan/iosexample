//
//  MeViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/1.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Eureka
import URLNavigator
import SafariServices

class SettingViewController: FormViewController {
    private let authService = container.resolve(OAuth2Service.self)!
    private let navigator = container.resolve(NavigatorType.self)!
    @objc private weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section(header: "通知", footer: "")
            
            <<< PasswordRow() {
                $0.title = "register.passwordfield.title".localized
                $0.cell.imageView?.image = AppIcons.lockAccent
                $0.placeholder = "register.passwordfield.placeholder".localized
                let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                    return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "register.passwordfield.validation.required".localized) : nil
                }
                $0.add(rule: ruleRequiredViaClosure)
                $0.cellUpdate { (cell, row) in //3
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
            }
            
            +++ Section(footer: "")
            <<< ButtonRow() {
                
                $0.title = "me.logoutbtn.title".localized
            }
            .onCellSelection { [weak self] (cell, row) in
                self?.logout()
            }
    }
    
    @IBAction func logout() -> Void {
        self.authService.logout()
        AppDelegate.shared.rootViewController.switchToLogout()
    }
}
