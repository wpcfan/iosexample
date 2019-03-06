//
//  PasswordView.swift
//  Example
//
//  Created by 王芃 on 2019/2/13.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import Layout
import PinLayout

class PasswordField: UITextField {
    private let disposeBag = DisposeBag()
    var enableIcon = true {
        didSet {
            self.leftViewMode = enableIcon ? .always : .never
        }
    }
    var enableSecretSwitch = true {
        didSet {
            self.rightViewMode = enableSecretSwitch ? .always : .never
        }
    }
    private var lockIcon: UIImageView?
    private var eyeButton: UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lockIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)).then {
            $0.image = AppIcons.lock
            $0.contentMode = .scaleAspectFill
        }
        eyeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30)).then {
            $0.setImage(AppIcons.eyeOff, for: .normal)
            $0.setImage(AppIcons.eye, for: .selected)
        }
        self.layoutIfNeeded()
        self.leftView = lockIcon
        self.leftViewMode = enableIcon ? .always : .never
        self.clearButtonMode = .whileEditing
        self.rightView = eyeButton
        self.rightViewMode = enableSecretSwitch ? .always : .never
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.eyeButton!.isSelected = !self.isSecureTextEntry
        eyeButton!.rx.tap
            .subscribe{ _ in
                self.isSecureTextEntry = self.eyeButton!.isSelected
                self.eyeButton!.isSelected = !self.eyeButton!.isSelected
            }
            .disposed(by: self.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PasswordField {
    open override class var expressionTypes: [String: RuntimeType] {
        var types = super.expressionTypes
        types["enableIcon"] = RuntimeType(Bool.self)
        types["enableSecretSwitch"] = RuntimeType(Bool.self)
        return types
    }
    open override func setValue(_ value: Any, forExpression name: String) throws {
        switch name {
        case "enableIcon":
            self.enableIcon = value as! Bool
        case "enableSecretSwitch":
            self.enableSecretSwitch = value as! Bool
        default:
            try super.setValue(value, forExpression: name)
        }
    }
}
