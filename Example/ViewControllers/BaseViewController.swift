//
//  BaseViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/17.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    // MARK: Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsUpdateConstraints()
    }
    
    func initialize() -> Void {
        
    }
    
}
