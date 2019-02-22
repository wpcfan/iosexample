//
//  DeviceCell.swift
//  Example
//
//  Created by 王芃 on 2019/2/8.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class DeviceCell: UITableViewCell {
    var onlineStatus = true {
        didSet {
            self.rebindButton.isHidden = onlineStatus
            self.onlineStatusLabel.textColor = onlineStatus ? .primary : .darkGray
        }
    }
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var onlineStatusLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var rebindButton: UIButton!
}
