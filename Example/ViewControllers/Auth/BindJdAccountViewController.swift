//
//  BindJdAccountViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/11.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout

class BindJdAccountViewController: UIViewController {
    private let jdSmartService = container.resolve(JdSmartCloudService.self)!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

extension BindJdAccountViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        jdSmartService.bindJdAccount(vc: self)
    }
}

#if !targetEnvironment(simulator)
extension BindJdAccountViewController: SCMAuthorizedInitManagerDelegate {
    func authorizedSuccessedCode(_ code: String!, state: String!) {
        
    }
}
#endif
