//
//  VerifySmsViewController.swift
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

class VerifySmsViewController: BaseViewController {
    var mobile: String?
    @objc weak var codeField: UITextField!
    @objc weak var scrollView: UIScrollView!
    @objc weak var nextButton: UIButton!
    @objc weak var countDownButton: UIButton!
    private let navigator = container.resolve(NavigatorType.self)!
    private let termSelected = BehaviorSubject<Bool>(value: true)
    private let captchaIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)).then {
        $0.image = AppIcons.captchaIcon
        $0.contentMode = .scaleAspectFill
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(
            named: "VerifySmsViewController.xml",
            state: [
                "formValid": false
            ],
            constants: [
                "captchaIcon": captchaIcon
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.presentDarkNavigationBar(.primary, .textIcon)
        let titleLabel = UILabel().then {
            $0.text = "verifySms.title".localized
            $0.textColor = .textIcon
            $0.sizeToFit()
        }
        self.navigationItem.titleView = titleLabel
    }
}

extension VerifySmsViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = VerifySmsViewControllerReactor()
    }
}

extension VerifySmsViewController: ReactorKit.View {
    typealias Reactor = VerifySmsViewControllerReactor
    func bind(reactor: Reactor) {
        
       codeField.rx.text.map{ code in !code.isBlank }
            .bind(to: self.layoutNode!.rx.state("formValid"))
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
                Reactor.Action.verifySms(mobile: self.mobile!, code: self.codeField.text!)
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
                
            }
            .disposed(by: self.disposeBag)
    }
}
