//
//  HomeViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/30.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import FSPagerView
import AlamofireImage
import RxSwift
import RxCocoa


class HomeViewController: UIViewController, LayoutLoading {
    
    fileprivate let REUSE_IDENTIFIER = "cell"
    fileprivate var dataSource: BannerDataSource?
    fileprivate var delegate: BannerViewDelegate?
    @IBOutlet var tableView: UITableView? {
        didSet {
            tableView?.registerLayout(
                named: "HomeTableCell.xml",
                forCellReuseIdentifier: "standaloneCell"
            )
        }
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }

    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutNode = LayoutNode(
            view: UITableView.self,
            expressions: [
                "backgroundColor": "tintColor",
                "contentInset.bottom": "safeAreaInsets.bottom",
                "contentInset.top": "safeAreaInsets.top",
                "contentInsetAdjustmentBehavior": "never",
                "contentOffset.y": "-safeAreaInsets.top",
                "estimatedSectionHeaderHeight": "20",
                "outlet": "tableView",
                "scrollIndicatorInsets.bottom": "safeAreaInsets.bottom",
                "scrollIndicatorInsets.top": "safeAreaInsets.top",
                "style": "plain"
            ],
            children: [
                LayoutNode(
                    view: UIView.self,
                    expressions: [
                        "height": "parent.height/4"
                    ],
                    children: [
                        LayoutNode(
                            view: FSPagerView.self,
                            expressions: [
                                "height": "parent.height",
                                "outlet": "pagerView"
                            ]
                        ),
                        LayoutNode(
                            view: FSPageControl.self,
                            expressions: [
                                "outlet": "pageControl",
                                "height": "30",
                                "bottom": "previous.bottom"
                            ]
                        )
                    ]
                )
            ]
        )
        dataSource = BannerDataSource()
        pagerView.dataSource = dataSource
        pageControl.numberOfPages = dataSource?.imageUrls.count ?? 0
        delegate = BannerViewDelegate(pageControl: pageControl)
        pagerView.delegate = delegate
        
        self.tableView?.configRefreshHeader(
            with: TableViewUtils.createHeader(),
            container: self,
            action: {
                log.debug("add refresh header to table view")
                self.tableView?.reloadData()
                self.tableView?.switchRefreshHeader(to: .normal(.success, 0.3))
            })
    }
}
