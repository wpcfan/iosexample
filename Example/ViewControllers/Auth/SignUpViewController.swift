//
//  RegisterViewController.swift
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

class SignUpViewController: BaseViewController {
    
    @objc weak var mobileField: UITextField!
    @objc weak var capchaField: UITextField!
    @objc weak var scrollView: UIScrollView!
    @objc weak var capchaImage: UIImageView!
    @objc weak var termsButton: UIButton!
    @objc weak var nextButton: UIButton!
    private let navigator = container.resolve(NavigatorType.self)!
    private let termSelected = BehaviorSubject<Bool>(value: true)
    private let captchaIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)).then {
        $0.image = AppIcons.captchaIcon
        $0.contentMode = .scaleAspectFill
    }
    private let mobileIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)).then {
        $0.image = AppIcons.mobileIcon
        $0.contentMode = .scaleAspectFill
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(
            named: "SignUpViewController.xml",
            state: [
                "captcha": UIImage(),
                "formValid": false
            ],
            constants: [
            "captchaIcon": captchaIcon,
            "mobileIcon": mobileIcon,
            "checkCircle": AppIcons.checkCircle,
            "uncheckCircle": AppIcons.uncheckCircle
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.presentDarkNavigationBar(.primary, .textIcon)
        self.title = "signup.title".localized
    }
    
    @objc func toggle(_ button: UIButton) {
        button.isSelected = !button.isSelected
        termSelected.onNext(button.isSelected)
    }
    
    @objc func showTerms() {
        navigator.push("https://sccloud.oss.cn-north-1.jcloudcs.com/smarthome/agreement.html")
    }
}

extension SignUpViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = SignUpViewControllerReactor()
    }
}

extension SignUpViewController: ReactorKit.View {
    typealias Reactor = SignUpViewControllerReactor
    func bind(reactor: Reactor) {
        weak var `self`: SignUpViewController! = self
        reactor.action.onNext(.getCaptcha)
        reactor.state.map { (state) -> UIImage? in
                state.captcha
            }
            .filterNil()
            .bind(to: self.layoutNode!.rx.state("captcha"))
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest([mobileField.rx.text.map{ mobile in !mobile.isBlank }, capchaField.rx.text.map{ captcha in !captcha.isBlank }, termSelected])
            .map { (vals) -> Bool in
                let mobile = vals[0]
                let captcha = vals[1]
                let terms = vals[2]
                return mobile && captcha && terms
            }
            .bind(to: self.layoutNode!.rx.state("formValid"))
            .disposed(by: self.disposeBag)
        
        capchaImage.rx.tapGesture().when(.recognized)
            .mapTo(Reactor.Action.getCaptcha)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [scrollView] keyboardVisibleHeight in
                scrollView!.contentInset.bottom = keyboardVisibleHeight
            })
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
        
        nextButton.rx.tap
            .map { _ in
                Reactor.Action.verifyCaptcha(mobile: self.mobileField.text!, code: self.capchaField.text!)
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.verification }
            .filter { (result) -> Bool in result }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ ev in
                guard ev.error == nil else { return }
                let vc = VerifySmsViewController()
                vc.mobile = self.mobileField.text!
                self.navigator.push(vc)
            }
            .disposed(by: self.disposeBag)
    }
}
