//
//  ChannelView.swift
//  Example
//
//  Created by 王芃 on 2018/10/21.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import Layout

class ChannelView: BaseView {
    var tappedIndex = PublishRelay<Int>()
    var channels$ = PublishRelay<[Channel]>()
    @objc weak var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadLayout(named: "ChannelView.xml")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutDidLoad(_: LayoutNode) {
        weak var `self`: ChannelView! = self
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Channel>>(configureCell: { (ds, cv, ip, item) -> UICollectionViewCell in
            let node = cv.dequeueReusableCellNode(withIdentifier: "templateCell", for: ip)
            node.setState([
                "imageUrl": item.imageUrl,
                "title": item.title
                ])
            return node.view as! UICollectionViewCell
        })
        channels$
            .map{ channels in
                [SectionModel(model: "Channels", items: channels)]
            }
            .bind(to: (self.collectionView.rx.items(dataSource: dataSource)))
            .disposed(by: disposeBag)
    }
}

extension ChannelView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedIndex.accept(indexPath.row)
    }
}

extension Reactive where Base: ChannelView {
    var channelTap: Observable<String> {
        return base.tappedIndex.asObservable()
            .withLatestFrom(base.channels$) {(idx, channels) -> String in
                channels[idx].link ?? ""
            }
    }
}
