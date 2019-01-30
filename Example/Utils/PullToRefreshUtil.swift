//
//  TableViewUtils.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//
import UIKit
import PullToRefreshKit

struct PullToRefreshUtil {
    static func createHeader() -> DefaultRefreshHeader {
        let header = DefaultRefreshHeader.header()
        header.setText("home.pulltorefresh.header".localized,
            mode: .pullToRefresh)
        header.setText("home.releasetorefresh.header".localized,
            mode: .releaseToRefresh)
        header.setText("home.refreshsuccess.header".localized,
            mode: .refreshSuccess)
        header.setText("home.refreshing.header".localized,
            mode: .refreshing)
        header.setText("home.refreshfailure.header".localized,
            mode: .refreshFailure)
        header.tintColor = .accent
        header.imageRenderingWithTintColor = true
        header.durationWhenHide = 0.4
        header.textLabel.tintColor = .accent
        return header
    }
}

class HomeRefreshHeader: UIView, RefreshableHeader{
    let iconImageView = UIImageView()// 这个ImageView用来显示下拉箭头
    let rotatingImageView = UIImageView() //这个ImageView用来播放动图
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        iconImageView.center = CGPoint(x: self.bounds.width/2.0, y: self.bounds.height/2.0)
        iconImageView.image = AppIcons.pullToRefresh
        rotatingImageView.image = AppIcons.refreshCircle
        rotatingImageView.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        addSubview(iconImageView)
        addSubview(rotatingImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.center = CGPoint(x: self.bounds.width / 2, y: self.frame.size.height - 30)
        rotatingImageView.center = CGPoint(x: self.bounds.width / 2, y: self.frame.size.height - 30)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - RefreshableHeader -
    func heightForHeader() -> CGFloat {
        return UIScreen.main.bounds.size.height / 3
    }
    
    func heightForFireRefreshing() -> CGFloat {
        return 120
    }
    
    func heightForRefreshingState() -> CGFloat {
        return 120
    }
    
    //监听状态变化
    func stateDidChanged(_ oldState: RefreshHeaderState, newState: RefreshHeaderState) {
        if newState == .pulling && oldState == .idle{
            UIView.animate(withDuration: 0.4, animations: {
                self.iconImageView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi + 0.000001)
            })
        }
        if newState == .idle{
            UIView.animate(withDuration: 0.4, animations: {
                self.iconImageView.transform = CGAffineTransform.identity
            })
        }
    }
    //松手即将刷新的状态
    func didBeginRefreshingState(){
        self.iconImageView.isHidden = true
        self.rotatingImageView.isHidden = false
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotateAnimation.duration = 0.8
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = 10000000
        self.rotatingImageView.layer.add(rotateAnimation, forKey: "rotate")
    }
    //刷新结束，将要隐藏header
    func didBeginHideAnimation(_ result:RefreshResult){
        self.rotatingImageView.isHidden = true
        self.iconImageView.isHidden = false
        self.iconImageView.layer.removeAllAnimations()
        self.iconImageView.layer.transform = CATransform3DIdentity
        self.iconImageView.image = AppIcons.release
    }
    //刷新结束，完全隐藏header
    func didCompleteHideAnimation(_ result:RefreshResult){
    }
}
