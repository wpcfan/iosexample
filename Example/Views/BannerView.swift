//
//  SliderView.swift
//  Example
//
//  Created by 王芃 on 2018/10/19.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import FSPagerView
import RxGesture
import SafariServices
import ReactorKit

class BannerView: BaseView, LayoutLoading, ReactorKit.View {
    typealias Reactor = BannerViewReactor
    fileprivate let REUSE_IDENTIFIER = "fspager"
    var banners: [Banner] = [
        Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080", label: "first", link: "http://baidu.com"),
        Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080", label: "second", link: "http://baidu.com"),
        Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080", label: "third", link: "http://baidu.com")
    ]
    
    @IBOutlet var pagerView: FSPagerView? {
        didSet {
            pagerView?.register(FSPagerViewCell.self, forCellWithReuseIdentifier: REUSE_IDENTIFIER)
            pagerView?.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var pagerControl: FSPageControl? {
        didSet {
            self.pagerControl?.numberOfPages = banners.count
            self.pagerControl?.contentHorizontalAlignment = .center
            self.pagerControl?.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pagerControl?.hidesForSinglePage = false
        }
    }
    
    @IBAction func presentWebView(url: NSString) -> Void {
        let vc = SFSafariViewController(url: URL(string: url as String)!)
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadLayout(named: "BannerView.xml")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure layout is updated after screen rotation, etc
        self.layoutNode?.view.frame = self.bounds
    }
    
    func bind(reactor: Reactor) {
        
    }
}

extension BannerView: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "fspager", at: index)
        cell.imageView?.pin_setImage(from: URL(string: banners[index].imageUrl!)!)
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

extension BannerView: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pagerControl?.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pagerControl?.currentPage = pagerView.currentIndex
    }
}
