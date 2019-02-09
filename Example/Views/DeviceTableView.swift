//
//  DeviceTableView.swift
//  Example
//
//  Created by 王芃 on 2019/2/8.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import Layout
import RxSwift
import RxDataSources
import RxGesture
import PinLayout
import SHSegmentedControl
import Haptica
import SwiftReorder

class DeviceTableView: SHTableView {
    var disposeBag = DisposeBag()
    var devices$ = BehaviorSubject<[Device]>(value: [])
    var reorder$ = PublishSubject<[String: Int]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.register(DeviceCell.self, forCellReuseIdentifier: "cell")
        self.reorder.delegate = self
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Device>>(configureCell: { ds, tv, ip, item in
            if let spacer = self.reorder.spacerCell(for: ip) {
                return spacer
            }
            let cell = tv.dequeueReusableCell(withIdentifier: "cell") as! DeviceCell
            cell.deviceNameLabel.text = item.deviceName
            cell.productImage.pin_setImage(from: URL(string: item.productImageUrl ?? ""), placeholderImage: AppIcons.devicePlaceholder)
            cell.onlineStatus = item.status == 1
            cell.rebindButton.rx.tap.asObservable().subscribe { ev in
                guard ev.error == nil else { return }
                
                }
                .disposed(by: cell.rx.reuseBag)
            cell.onlineStatusLabel.text = item.status == 1 ? "设备在线" : "设备离线"
            return cell
        })
        
        devices$
            .map{ devices in
                [SectionModel(model: "我的设备", items: devices)]
            }
            .bind(to: (self.rx.items(dataSource: dataSource)))
            .disposed(by: disposeBag)
        
        self.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.rx.longPressGesture()
            .when(.began)
            .asObservable()
            .subscribe { ev in
                guard ev.error == nil else { return }
                Haptic.play("..oO-Oo..", delay: 0.1)
            }
            .disposed(by: disposeBag)
        
        reorder$
            .withLatestFrom(devices$) { indices, items in
                guard indices["sourceIndex"] != nil && indices["targetIndex"] != nil else { return items }
                let item = items[indices["sourceIndex"]!]
                var newItems = items
                newItems.remove(at: indices["sourceIndex"]!)
                newItems.insert(item, at: indices["targetIndex"]!)
                return newItems
            }.bind(to: devices$)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rebindDevice(_ device: Device) {
        
    }
}

extension DeviceTableView: UITableViewDelegate {
    fileprivate func buildSectionHeader() -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "我的设备"
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension DeviceTableView: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.reorder$.onNext([
            "sourceIndex": sourceIndexPath.row,
            "targetIndex": destinationIndexPath.row
            ])
    }
}
