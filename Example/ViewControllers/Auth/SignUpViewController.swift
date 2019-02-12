//
//  RegisterViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/12.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Foundation

class RegisterViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(named: "RegisterViewController.xml", constants: [
            "captchaIcon": AppIcons.captchaIcon,
            "mobileIcon": AppIcons.mobileIcon
            ])
    }
}

extension RegisterViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = AuthViewControllerReactor()
    }
}
