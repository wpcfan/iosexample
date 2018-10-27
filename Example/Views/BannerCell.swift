//
//  BannerCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import FSPagerView
import RxGesture
import SafariServices
import ReactorKit

class BannerCell: BaseItemCell, ReactorKit.View {
    typealias Reactor = BannerViewReactor
    fileprivate static let REUSE_IDENTIFIER = "fspager"
    var banners: Array<Banner> = []

    private var pagerView = FSPagerView().then {
        $0.register(FSPagerViewCell.self, forCellWithReuseIdentifier: REUSE_IDENTIFIER)
        $0.itemSize = FSPagerView.automaticSize
    }
    
    private var pageControl = FSPageControl().then {
        $0.contentHorizontalAlignment = .center
        $0.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    @IBAction func presentWebView(url: NSString) -> Void {
        let vc = SFSafariViewController(url: URL(string: url as String)!)
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    override func initialize() {
        pagerView.delegate = self
        pagerView.dataSource = self
        self.contentView.addSubview(pagerView)
        self.contentView.addSubview(pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.sizeToFit()
        pagerView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        pageControl.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(32)
        }
        pageControl.numberOfPages = banners.count
    }
    
    func bind(reactor: Reactor) {
        
    }
}

extension BannerCell: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: BannerCell.REUSE_IDENTIFIER, at: index)
        cell.imageView?.pin_setImage(from: URL(string: banners[index].imageUrl!))
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = banners[index].label
        cell.rx.imageTap
            .subscribe({ _ in
                self.presentWebView(url: self.banners[index].link! as NSString)
            })
            .disposed(by: cell.rx.reuseBag)
        return cell
    }
}

extension BannerCell: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}
