//
//  CaptchaView.swift
//  Example
//
//  Created by 王芃 on 2019/2/13.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout

class CaptchaView: BaseView {
    @objc weak var mobileField: UITextField!
    @objc weak var capchaField: UITextField!
    @objc weak var capchaImage: UIImageView!
    private let captchaIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)).then {
        $0.image = AppIcons.captchaIcon
        $0.contentMode = .scaleAspectFill
    }
    private let mobileIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)).then {
        $0.image = AppIcons.mobileIcon
        $0.contentMode = .scaleAspectFill
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadLayout(
            named: "CaptchaView.xml",
            constants: [
                "captchaIcon": captchaIcon,
                "mobileIcon": mobileIcon,
            ]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutDidLoad(_ layoutNode: LayoutNode) {
        
    }
}
