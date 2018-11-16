//
//  ProfileCell.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

class ProfileCell: BaseItemCell {
    
    private let avatarView = UIImageView().then {
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    private let mobileLabel = UILabel()
    private let nameLabel = UILabel()
    private let labelView = UIView()
    
    var profile: User? {
        didSet {
            guard let profile = profile else { return }
            initControls(profile: profile)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.safeAreaLayoutGuide)
            }
        }
        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.left.top.equalToSuperview().offset(5)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.top).offset(5)
            make.left.equalTo(avatarView.snp.right).offset(5)
            make.height.equalTo(16)
        }
        mobileLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel)
            make.height.equalTo(16)
        }
    }
    
    override func initialize() {
        labelView.addSubview(mobileLabel)
        labelView.addSubview(nameLabel)
        contentView.addSubview(avatarView)
        contentView.addSubview(labelView)
    }
    
    private func initControls(profile: User) {
        avatarView.pin_setImage(from: URL(string: profile.avatar!))
        mobileLabel.text = profile.mobile
        nameLabel.text = profile.name
    }
}
