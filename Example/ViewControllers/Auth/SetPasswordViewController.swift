//
//  SetPasswordViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/12.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import ReactorKit
import URLNavigator
import RxSwift
import RxGesture
import RxKeyboard
import RxCocoa

class SetPasswordViewController: BaseViewController {
    var mobile: String?
    @objc weak var passwordField: UITextField!
    @objc weak var repeatField: UITextField!
    @objc weak var scrollView: UIScrollView!
    @objc weak var nextButton: UIButton!
    private let navigator = container.resolve(NavigatorType.self)!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(
            named: "SetPasswordViewController.xml",
            state: [
                "formValid": false,
                "pwdVisible": false,
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.presentDarkNavigationBar(.primary, .textIcon)
        self.setNavigationTitle("setPassword.title".localized)
    }
}

extension SetPasswordViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = SetPasswordViewControllerReactor()
        passwordField.setBottomBorder(withColor: .lightGray)
        repeatField.setBottomBorder(withColor: .lightGray)
    }
}

extension SetPasswordViewController: ReactorKit.View {
    typealias Reactor = SetPasswordViewControllerReactor
    func bind(reactor: Reactor) {
        Observable.combineLatest(passwordField.rx.text, repeatField.rx.text)
            .map { (pwd, rep) -> Bool in
                guard let pwd = pwd, let rep = rep else { return false }
                return pwd == rep && pwd.count >= 8 && pwd.count < 16
            }
            .bind(to: self.layoutNode!.rx.state("formValid"))
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
        
        nextButton.rx.tap
            .map { _ in
                Reactor.Action.setPassword(mobile: self.mobile!, password: self.passwordField.text!)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [scrollView] keyboardVisibleHeight in
                scrollView!.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.user }
            .filterNil()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ ev in
                guard ev.error == nil else { return }
                DiskUtil.saveUser(user: ev.element)
                let vc = BindJdAccountViewController()
                self.navigator.push(vc)
            }
            .disposed(by: self.disposeBag)
    }
}
