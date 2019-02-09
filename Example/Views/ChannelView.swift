//
//  ChannelView.swift
//  Example
//
//  Created by 王芃 on 2018/10/21.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ReactorKit
import RxSwift
import RxDataSources

class ChannelView: UICollectionView {
    var tappedIndex = PublishSubject<Int>()
    var channels$ = BehaviorSubject<[Channel]>(value: [])
    var disposeBag = DisposeBag()
    
    convenience init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 0)
        let itemWidth = (UIScreen.main.bounds.width - 5 * 10) / 5
        layout.itemSize = CGSize(width: itemWidth, height: 69.0)
        layout.minimumInteritemSpacing = 10
        self.init(frame: frame, collectionViewLayout: layout)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.contentInset = UIEdgeInsets(top: 0, left: pin.safeArea.left, bottom: 0, right: pin.safeArea.right)
        self.backgroundColor = .white
        register(ChannelCell.self, forCellWithReuseIdentifier: "templateCell")
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Channel>>(configureCell: { (ds, cv, ip, item) -> UICollectionViewCell in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "templateCell", for: ip) as! ChannelCell
            cell.channel = item
            return cell
        })
        channels$
            .map{ channels in
                [SectionModel(model: "Channels", items: channels)]
            }
            .bind(to: (self.rx.items(dataSource: dataSource)))
            .disposed(by: disposeBag)
        self.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChannelView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedIndex.onNext(indexPath.row)
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
