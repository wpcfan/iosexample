//
//  SceneTableView.swift
//  Example
//
//  Created by 王芃 on 2019/2/8.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import PinLayout
import RxSwift
import RxDataSources
import ReactorKit
import SHSegmentedControl

class SceneTableView: SHTableView {
    var disposeBag = DisposeBag()
    var loadScenes$ = PublishSubject<Void>()
    let sectionHeaderView = SectionHeaderView()
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        register(SceneCell.self, forCellReuseIdentifier: "cell")
        reactor = SceneTableViewReactor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SceneTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionHeaderView.textLabel.text = "scenes.section.header".localized
        sectionHeaderView.icon.image = AppIcons.menuScenes
        return sectionHeaderView
    }
}

extension Reactive where Base: SceneTableView {
    var addSceneTapped: Observable<Void> {
        return base.sectionHeaderView.rightBtnTapped.asObservable()
    }
}

extension SceneTableView: ReactorKit.View {
    typealias Reactor = SceneTableViewReactor
    
    func bind(reactor: SceneTableViewReactor) {
        weak var `self`: SceneTableView! = self
        reactor.action.onNext(.load)
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, HouseScene>>(configureCell: { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell")
            cell?.imageView?.image = AppIcons.homePrimary.withRenderingMode(.alwaysTemplate)
            cell?.imageView?.tintColor = UIColor.blue
            cell!.textLabel?.text = item.scene?.displayName
            return cell!
        })
        
        loadScenes$
            .mapTo(Reactor.Action.load)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { state in
                [SectionModel(model: "title", items: state.scenes)]
            }
            .bind(to: self.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}
