//
//  BannerDataSource.swift
//  Example
//
//  Created by 王芃 on 2018/10/11.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import FSPagerView
import RxSwift
import RxCocoa
import Moya_ObjectMapper

class BannerDataSource: NSObject, FSPagerViewDataSource {
    fileprivate let REUSE_IDENTIFIER = "cell"
    private var disposeBag = DisposeBag()
    var imageUrls: Array<String> = [
        "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080",
        "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080",
        "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080"
    ]
    
    override init() {
        super.init()
        HomeProvider.request(.banners)
            .filterSuccessfulStatusCodes()
            .mapArray(Banner.self)
            .subscribe { event -> Void in
                switch event {
                case .success(let banners):
                    log.debug(banners)
                    self.imageUrls = banners.map({ (banner) -> String in
                        banner.imageUrl!
                    })
                case .error(let err):
                    log.error(err.localizedDescription)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageUrls.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, at: index)
        cell.imageView?.af_setImage(withURL: URL(string: imageUrls[index])!)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = index.description+index.description
        return cell
    }
}
