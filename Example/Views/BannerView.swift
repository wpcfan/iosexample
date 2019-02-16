//
//  SliderView.swift
//  Example
//
//  Created by 王芃 on 2018/10/19.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import PinLayout
import FSPagerView
import RxGesture
import SafariServices
import RxSwift
import RxOptional

class BannerView: UIView {
    
    var tappedIndex = PublishSubject<Int?>()
    var banners: [Banner] = [] {
        didSet {
            self.pagerControl.numberOfPages = banners.count
            self.pagerView.reloadData()
        }
    }
    
    @objc weak var pagerView: FSPagerView!
    
    @objc weak var pagerControl: FSPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pagerView = FSPagerView().then {
            $0.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "fspager")
            $0.itemSize = FSPagerView.automaticSize
            $0.automaticSlidingInterval = 3.0
            $0.isInfinite = true
            $0.transformer = FSPagerViewTransformer(type: .crossFading)
        }
        pagerControl = FSPageControl().then {
            $0.contentHorizontalAlignment = .center
            $0.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.hidesForSinglePage = false
        }
        pagerView.dataSource = self
        pagerView.delegate = self
        addSubview(pagerView)
        addSubview(pagerControl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pagerView.pin.all()
        pagerControl.pin.left().bottom().right().height(20)
    }
}

extension BannerView: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "fspager", at: index)
        cell.imageView?.pin_setImage(from: URL(string: banners[index].imageUrl!))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = banners[index].title
        cell.rx.imageTap
            .map { _ in index }
            .bind(to: self.tappedIndex)
            .disposed(by: cell.rx.reuseBag)
        return cell
    }
}

extension BannerView: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pagerControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pagerControl.currentPage = pagerView.currentIndex
    }
}

extension Reactive where Base: BannerView {
    var bannerImageTap: Observable<String> {
        return base.tappedIndex.asObservable()
            .filterNil()
            .map { (idx) -> String? in self.base.banners[idx].link }
            .filterNil()
    }
}
