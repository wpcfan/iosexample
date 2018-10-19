//
//  BannerCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import FSPagerView
import SnapKit
import PINRemoteImage
import RxGesture
import SafariServices

class BannerCell: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {
    
    fileprivate let REUSE_IDENTIFIER = "fspager"
    fileprivate var banners: Array<Banner> = []
    
    @IBOutlet weak var pagerView: FSPagerView? {
        didSet {
            self.pagerView?.register(FSPagerViewCell.self, forCellWithReuseIdentifier: REUSE_IDENTIFIER)
            self.pagerView?.itemSize = FSPagerView.automaticSize
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl? {
        didSet {
            self.pageControl?.contentHorizontalAlignment = .center
            self.pageControl?.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    @IBAction func presentWebView(url: NSString) -> Void {
        let vc = SFSafariViewController(url: URL(string: url as String)!)
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    var item: HomeViewModelItem? {
        didSet {
            guard let item = item as? HomeViewModelBannerItem else {
                return
            }
            self.banners = item.banners
            log.debug("banners assigned to HomeViewModelItem", userInfo: ["banners": banners])
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(pagerView!)
        self.pagerView?.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        self.contentView.addSubview(pageControl!)
        pageControl?.numberOfPages = banners.count
        pageControl?.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalTo((self.pagerView?.snp.bottom)!)
            make.height.equalTo(32)
        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, at: index)
        cell.imageView?.pin_setImage(from: URL(string: banners[index].imageUrl!)!)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = banners[index].label
        cell.imageView?.rx.tapGesture().when(.recognized)
            .subscribe({ _ in
                self.presentWebView(url: self.banners[index].link! as NSString)
            })
            .disposed(by: cell.rx.reuseBag)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl?.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl?.currentPage = pagerView.currentIndex
    }
}
