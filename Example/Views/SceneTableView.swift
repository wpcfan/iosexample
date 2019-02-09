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
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
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
    fileprivate func buildSectionHeader() -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "我的场景"
        let icon = UIImageView(image: AppIcons.scene)
        icon.pin.width(20).height(20)
        view.addSubview(icon)
        view.addSubview(label)
        icon.pin.left(5).top(5).width(24).height(24)
        label.pin.after(of: icon).width(200).height(24).top(5).marginLeft(5)
        view.sizeToFit()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return buildSectionHeader()
    }
}
