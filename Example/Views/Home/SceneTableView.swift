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
import Haptica
import SwiftReorder

class SceneTableView: SHTableView {
    var disposeBag = DisposeBag()
    var loadScenes$ = PublishSubject<Void>()
    var reorder$ = PublishSubject<[String: Int]>()
    var sceneSelected$ = PublishSubject<HouseScene>()
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

extension SceneTableView: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.reorder$.onNext([
            "sourceIndex": sourceIndexPath.row,
            "targetIndex": destinationIndexPath.row
            ])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

extension SceneTableView: ReactorKit.View {
    typealias Reactor = SceneTableViewReactor
    
    func bind(reactor: SceneTableViewReactor) {
        weak var `self`: SceneTableView! = self
        self.reorder.delegate = self
        reactor.action.onNext(.load)
        
        let scenes$ = reactor.state.map { state in state.scenes }
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, HouseScene>>(configureCell: { ds, tv, ip, item in
            if let spacer = self.reorder.spacerCell(for: ip) {
                return spacer
            }
            let cell = tv.dequeueReusableCell(withIdentifier: "cell") as! SceneCell
            cell.selectionStyle = .none
            cell.textLabel?.text = item.scene?.displayName
            switch(item.innerCode) {
            case 1:
                cell.sceneType = .goHome
                break
            case 2:
                cell.sceneType = .leaveHome
                break
            default:
                cell.sceneType = .other
                break
            }
            cell.deviceCount.text = "\(item.scene?.deviceCount ?? 0)"
            return cell
        })
        
        loadScenes$
            .mapTo(Reactor.Action.load)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.longPressGesture().when(.began)
            .subscribe { ev in
                guard ev.error == nil else { return }
                Haptic.play("..oO-Oo..", delay: 0.1)
            }
            .disposed(by: disposeBag)
        
        reorder$
            .subscribe { ev in
                guard ev.error == nil else { return }
                Haptic.play("..o..", delay: 0.1)
            }
            .disposed(by: disposeBag)
        
        scenes$
            .map { scenes in
                [SectionModel(model: "title", items: scenes)]
            }
            .bind(to: self.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reorder$
            .map { Reactor.Action.startReorder($0["sourceIndex"]!, $0["targetIndex"]!)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.itemSelected
            .map { idx in idx.row }
            .withLatestFrom(scenes$) { (row, scenes) in
                scenes[row]
            }
            .bind(to: sceneSelected$)
            .disposed(by: disposeBag)
        
        self.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: SceneTableView {
    var addSceneTapped: Observable<Void> {
        return base.sectionHeaderView.rightBtnTapped.asObservable()
    }
    var sceneSelected: Observable<HouseScene> {
        return base.sceneSelected$.asObservable()
    }
}
