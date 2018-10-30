//
//  TableViewUtils.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import PullToRefreshKit

struct TableViewUtils {
    static func createHeader() -> DefaultRefreshHeader {
        let header = DefaultRefreshHeader.header()
        header.setText(
            NSLocalizedString("home.pulltorefresh.header", comment: ""),
            mode: .pullToRefresh)
        header.setText(
            NSLocalizedString("home.releasetorefresh.header", comment: ""),
            mode: .releaseToRefresh)
        header.setText(
            NSLocalizedString("home.refreshsuccess.header", comment: ""),
            mode: .refreshSuccess)
        header.setText(
            NSLocalizedString("home.refreshing.header", comment: ""),
            mode: .refreshing)
        header.setText(
            NSLocalizedString("home.refreshfailure.header", comment: ""),
            mode: .refreshFailure)
        header.tintColor = UIColor.accent
        header.imageRenderingWithTintColor = true
        header.durationWhenHide = 0.4
        return header
    }
}
