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

class MeViewController: FormViewController {
    private let authService = container.resolve(OAuth2Service.self)!
    private let navigator = container.resolve(NavigatorType.self)!
    @IBOutlet private weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section(header: "通知", footer: "")
            
            <<< PasswordRow() {
                $0.title = NSLocalizedString("register.passwordfield.title", comment: "")
                $0.cell.imageView?.image = AppIcons.lockAccent
                $0.placeholder = NSLocalizedString("register.passwordfield.placeholder", comment: "")
                let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                    return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: NSLocalizedString("register.passwordfield.validation.required", comment: "")) : nil
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
                
                $0.title = NSLocalizedString("me.logoutbtn.title", comment: "")
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
