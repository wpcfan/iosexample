//
//  SliderView.swift
//  Example
//
//  Created by 王芃 on 2018/10/19.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import FSPagerView
import RxGesture
import SafariServices
import ReactorKit
import RxSwift
import URLNavigator
import RxOptional

class BannerView: BaseView {
    
    fileprivate let REUSE_IDENTIFIER = "fspager"
    var selectedIndex = PublishSubject<Int?>()
    var tappedIndex = PublishSubject<Int?>()
    
    @objc var layoutNode: LayoutNode? {
        didSet {
            self.reactor = BannerViewReactor()
        }
    }
    var banners: [Banner] = []
    
    @objc var pagerView: FSPagerView? {
        didSet {
            pagerView?.register(FSPagerViewCell.self, forCellWithReuseIdentifier: REUSE_IDENTIFIER)
            pagerView?.itemSize = FSPagerView.automaticSize
            pagerView?.automaticSlidingInterval = 3.0
            pagerView?.isInfinite = true
            pagerView?.transformer = FSPagerViewTransformer(type: .crossFading)
        }
    }
    
    @objc weak var pagerControl: FSPageControl? {
        didSet {
            self.pagerControl?.contentHorizontalAlignment = .center
            self.pagerControl?.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pagerControl?.hidesForSinglePage = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadLayout(
            named: "BannerView.xml"
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        cell.textLabel?.text = banners[index].label
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
        self.pagerControl?.currentPage = targetIndex
        self.selectedIndex.onNext(targetIndex)
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pagerControl?.currentPage = pagerView.currentIndex
        self.selectedIndex.onNext(pagerView.currentIndex)
    }
}

extension BannerView: ReactorKit.View {
    typealias Reactor = BannerViewReactor
    func bind(reactor: Reactor) {
        reactor.action.onNext(.load)

        reactor.state.map { $0.banners }
            .debug()
            .subscribe { ev in
                self.banners = ev.element!
                self.pagerControl?.numberOfPages = ev.element!.count
                self.pagerView?.reloadData()
            }
            .disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: BannerView {
    var bannerImageTap: Observable<String> {
        return base.tappedIndex.asObservable()
            .filterNil()
            .distinctUntilChanged()
            .map { (idx) -> String? in self.base.banners[idx].link }
            .filterNil()
    }
    
    var bannerImageSelect: Observable<String> {
        return base.selectedIndex.asObservable()
            .filterNil()
            .distinctUntilChanged()
            .map { (idx) -> String? in self.base.banners[idx].imageUrl }
            .filterNil()
    }
}
