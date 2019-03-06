//
//  DeviceTableView.swift
//  Example
//
//  Created by 王芃 on 2019/2/8.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import Layout
import RxCocoa
import RxSwift
import RxDataSources
import RxGesture
import PinLayout
import SHSegmentedControl
import Haptica
import SwiftReorder

class DeviceTableView: SHTableView {
    var disposeBag = DisposeBag()
    var devices$ = PublishRelay<[JdDevice]>()
    var reorder$ = PublishRelay<[String: Int]>()
    var rebind$ = PublishRelay<JdDevice>()
    var deviceSelected$ = PublishRelay<JdDevice>()
    var sectionHeaderView = SectionHeaderView()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        weak var `self`: DeviceTableView! = self
        register(UINib(nibName: "DeviceCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.reorder.delegate = self
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, JdDevice>>(configureCell: { ds, tv, ip, item in
            if let spacer = self.reorder.spacerCell(for: ip) {
                return spacer
            }
            let cell = tv.dequeueReusableCell(withIdentifier: "cell") as! DeviceCell
            cell.selectionStyle = .none
            cell.deviceNameLabel.text = item.deviceName
            cell.productTypeLabel.text = item.from
            cell.productImageView.pin_setImage(from: URL(string: item.productImageUrl ?? ""), placeholderImage: AppIcons.devicePlaceholder)
            cell.onlineStatus = item.status == 1
            cell.rebindButton.setTitle("devices.cell.rebind".localized, for: .normal)
            cell.rebindButton.rx.tap
                .subscribe { ev in
                    guard ev.error == nil else { return }
                    self.rebind$.accept(item)
                    }
                .disposed(by: cell.rx.reuseBag)
            cell.onlineStatusLabel.text = item.status == 1 ? "devices.cell.online".localized : "devices.cell.offline".localized
            return cell
        })
        
        devices$.map{ devices in [SectionModel(model: "devices.section.header".localized, items: devices)] }
            .debug()
            .bind(to: self.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.rx.setDelegate(self)
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
        
        reorder$.withLatestFrom(devices$) { indices, items in
                guard indices["sourceIndex"] != nil && indices["targetIndex"] != nil else { return items }
                let item = items[indices["sourceIndex"]!]
                var newItems = items
                newItems.remove(at: indices["sourceIndex"]!)
                newItems.insert(item, at: indices["targetIndex"]!)
                return newItems
            }
            .bind(to: devices$)
            .disposed(by: disposeBag)
        
        self.rx.itemSelected
            .map { idx in idx.row }
            .withLatestFrom(devices$) { (row, devices) in
                devices[row]
            }
            .bind(to: deviceSelected$)
            .disposed(by: disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rebindDevice(_ device: JdDevice) {
        
    }
}

extension DeviceTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        sectionHeaderView.textLabel.text = "devices.section.header".localized
        sectionHeaderView.icon.image = AppIcons.menuDevices
        return sectionHeaderView
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
        self.reorder$.accept([
            "sourceIndex": sourceIndexPath.row,
            "targetIndex": destinationIndexPath.row
            ])
    }
}

extension Reactive where Base: DeviceTableView {
    var addDeviceTapped: Observable<Void> {
        return base.sectionHeaderView.rightBtnTapped.asObservable()
    }
    var rebind: Observable<JdDevice> {
        return base.rebind$.asObservable()
    }
    var deviceSelected: Observable<JdDevice> {
        return base.deviceSelected$.asObservable()
    }
}
