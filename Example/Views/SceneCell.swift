//
//  SceneCell.swift
//  Example
//
//  Created by 王芃 on 2019/2/26.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import PinLayout

enum SceneType {
    case goHome
    case leaveHome
    case other
}

class SceneCell: UITableViewCell {
    
    var sceneType: SceneType? {
        didSet {
            guard let sceneType = sceneType else {
                self.imageView?.image = AppIcons.menuScenes
                return
            }
            switch sceneType {
            case .goHome:
                self.imageView?.image = AppIcons.homePrimary
                break
            case .leaveHome:
                self.imageView?.image = AppIcons.sceneWorkAccent
                break
            case .other:
                self.imageView?.image = AppIcons.menuScenes
            }
        }
    }
    
    let deviceIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = AppIcons.devices
    }
    let deviceCount = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
    }
    let manualButton = UIButton(type: .custom).then {
        $0.contentMode = .scaleAspectFill
        $0.setImage(AppIcons.manualExecute, for: .normal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(deviceIcon)
        addSubview(deviceCount)
        addSubview(manualButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        manualButton.pin.right(10).size(30).vCenter().marginHorizontal(10)
        deviceCount.pin.before(of: manualButton).width(26).height(20).vCenter()
        deviceIcon.pin.before(of: deviceCount).size(30).vCenter()
        self.textLabel?.pin.horizontallyBetween(self.imageView!, and: deviceIcon).vCenter().sizeToFit(.width).marginHorizontal(10)
    }
}
