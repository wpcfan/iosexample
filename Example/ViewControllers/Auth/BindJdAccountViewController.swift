//
//  BindJdAccountViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/11.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import RxSwift
import ReactorKit
import URLNavigator

class BindJdAccountViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    private let codeReceived = PublishSubject<String>()
    private let jdSmartService = container.resolve(JdSmartCloudService.self)!
    private let navigator = container.resolve(NavigatorType.self)!
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
        reactor = BindJdAccountViewControllerReactor()
    }
}

extension BindJdAccountViewController: ReactorKit.View {
    typealias Reactor = BindJdAccountViewControllerReactor
    
    func bind(reactor: Reactor) {
        self.rx.viewDidAppear.asObservable()
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribe { _ in
                self.rebind()
            }
            .disposed(by: disposeBag)
        
        codeReceived.map { (code) -> Reactor.Action in
                Reactor.Action.bindAccount(code: code)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
            .map { $0.user }
            .filterNil()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ ev in
                guard ev.error == nil else { return }
                DiskUtil.saveUser(user: ev.element)
                let vc = HomeViewController()
                self.navigator.push(vc)
            }
            .disposed(by: self.disposeBag)
    }
}

#if !targetEnvironment(simulator)
extension BindJdAccountViewController: SCMAuthorizedInitManagerDelegate {
    func authorizedSuccessedCode(_ code: String!, state: String!) {
        self.codeReceived.onNext(code)
    }
}
#endif
