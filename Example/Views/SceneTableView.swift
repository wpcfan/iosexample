//
//  SceneTableView.swift
//  Example
//
//  Created by 王芃 on 2019/2/8.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import RxDataSources
import PinLayout
import SHSegmentedControl

class BasicTableCell: BaseTableCell {
    
}

class SceneTableView: SHTableView {
    var disposeBag = DisposeBag()
    var scenes$ = BehaviorSubject<[Scene]>(value: [
        Scene(JSON: ["name": "回家"])!,
        Scene(JSON: ["name": "离家"])!])
    let sectionHeaderView = SectionHeaderView()
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        weak var `self`: SceneTableView! = self
        register(BasicTableCell.self, forCellReuseIdentifier: "cell")
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Scene>>(configureCell: { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell")
            cell!.textLabel?.text = item.name
            return cell!
        })
        scenes$
            .map { scenes in
                [SectionModel(model: "title", items: scenes)]
            }
            .bind(to: self.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.rx.setDelegate(self)
            .disposed(by: disposeBag)
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
        sectionHeaderView.icon.image = AppIcons.scene
        return sectionHeaderView
    }
}

extension Reactive where Base: SceneTableView {
    var addSceneTapped: Observable<Void> {
        return base.sectionHeaderView.rightBtnTapped.asObservable()
    }
}
