//
//  BindJdAccountViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/11.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import RxSwift

class BindJdAccountViewController: UIViewController {
    private let jdSmartService = container.resolve(JdSmartCloudService.self)!
    private var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        #if !targetEnvironment(simulator)
        SCMAuthorizedInitManager.shared()?.delegate = self
        #endif
        loadLayout(
            named: "BindJdAccountViewController.xml",
            constants: [
                "JdLogo": UIImage(named: "JdLogo")!
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.presentDarkNavigationBar(UIColor.primary, UIColor.textIcon)
        self.setNavigationTitle("bindJdAccount.title".localized)
    }
    
    @objc func rebind() {
        jdSmartService.bindJdAccount(vc: self)
    }
}

extension BindJdAccountViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        
        self.rx.viewDidAppear.asObservable()
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribe { _ in
                self.rebind()
            }
            .disposed(by: disposeBag)
    }
}

#if !targetEnvironment(simulator)
extension BindJdAccountViewController: SCMAuthorizedInitManagerDelegate {
    func authorizedSuccessedCode(_ code: String!, state: String!) {
        print(code)
    }
}
#endif
