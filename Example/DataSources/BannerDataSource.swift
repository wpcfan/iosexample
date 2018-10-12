//
//  BannerDataSource.swift
//  Example
//
//  Created by 王芃 on 2018/10/11.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import FSPagerView

class BannerDataSource: NSObject, FSPagerViewDataSource {
    let countOfImages: Int
    let imageUrls: Array<String>
    
    init() {
        HomeProvider.request(.banners)
            .filterSuccessfulStatusCodes()
            .mapObject()
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
    }
}
