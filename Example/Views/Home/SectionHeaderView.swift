//
//  DeviceHeaderView.swift
//  Example
//
//  Created by 王芃 on 2019/2/10.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import PinLayout
import RxSwift
import RxCocoa
import RxGesture

class SectionHeaderView: UIView {
    var disposeBag = DisposeBag()
    var rightBtnTapped = PublishRelay<Void>()
    var rightBtnHidden = true {
        didSet {
            self.rightIcon.isHidden = rightBtnHidden
        }
    }
    let textLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .black
        $0.font = $0.font.withSize(16)
    }
    let icon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    let rightIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = AppIcons.add
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        addSubview(self.icon)
        addSubview(self.textLabel)
        addSubview(self.rightIcon)
        self.rightIcon.isHidden = rightBtnHidden
        rightIcon.rx.tapGesture().when(.recognized).asObservable()
            .void()
            .bind(to: self.rightBtnTapped)
            .disposed(by: self.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let iconSize: CGFloat = 24
        icon.pin.left(10).top(5).size(iconSize)
        textLabel.pin.after(of: icon, aligned: .center).width(200).height(20).marginHorizontal(10)
        rightIcon.pin.topRight(to: self.anchor.topRight).size(40)
        self.sizeToFit()
    }
}
