//
//  DeviceListViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/26.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift
import RxDataSources
import PinLayout

enum TableViewEditingCommand {
    case MoveItem(sourceIndex: IndexPath, destinationIndex: IndexPath)
    case DeleteItem(IndexPath)
}

class DeviceCell: BaseTableCell {
    var onlineStatus = true
    let productImage = UIImageView()
    let deviceNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = $0.font.withSize(14)
    }
    let onlineStatusLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .primary
        $0.font = $0.font.withSize(12)
    }
    let productTypeLabel = UILabel().then {
        $0.text = "京东智能设备"
        $0.font = $0.font.withSize(12)
        $0.textAlignment = .right
    }
    let rebindButton = UIButton().then {
        $0.setTitle("重新配网", for: .normal)
        $0.titleLabel?.font = $0.titleLabel?.font.withSize(12)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
    }
    
    override func initialize() {
        super.initialize()
        
        self.contentView.addSubview(productImage)
        self.contentView.addSubview(deviceNameLabel)
        self.contentView.addSubview(onlineStatusLabel)
        self.contentView.addSubview(productTypeLabel)
        self.contentView.addSubview(rebindButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        productImage.pin
            .left()
            .vCenter()
            .width(80)
            .aspectRatio(1)
        deviceNameLabel.pin
            .after(of: productImage)
            .top(10)
            .width(50%)
            .height(20)
        onlineStatusLabel.pin
            .left(to: deviceNameLabel.edge.left)
            .bottom(20)
            .width(100)
            .height(12)
        productTypeLabel.pin
            .after(of: deviceNameLabel, aligned: .top)
            .width(20%)
            .height(20)
        rebindButton.pin
            .below(of: productTypeLabel, aligned: .right)
            .marginTop(10)
            .width(80)
            .height(20)
        rebindButton.isHidden = onlineStatus
    }
}

class DeviceListViewController: BaseViewController, TableViewPage, TopTabContent {
    
    var pageIndex: Int?
    var devices$ = BehaviorSubject<[Device]>(value: [])
    private var refreshHeaderTrigger = PublishSubject<Void>()
    
    @objc var tableView: UITableView? = UITableView().then {
        $0.register(DeviceCell.self, forCellReuseIdentifier: "cell")
        $0.estimatedRowHeight = 80
    }
    
    weak var delegate: UITableViewDelegate?
    
    func rebindDevice(_ device: Device) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageIndex = 1
        self.view = tableView
        self.tableView?.isEditing = true
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Device>>(configureCell: { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell") as! DeviceCell
            cell.deviceNameLabel.text = item.deviceName
            cell.productImage.pin_setImage(from: URL(string: item.productImageUrl ?? ""), placeholderImage: AppIcons.devicePlaceholder)
            cell.onlineStatus = item.status == 1
            cell.rebindButton.rx.tap.asObservable().subscribe { ev in
                guard ev.error == nil else { return }
                self.rebindDevice(item)
                }
                .disposed(by: cell.rx.reuseBag)
            cell.onlineStatusLabel.text = item.status == 1 ? "设备在线" : "设备离线"
            return cell
        }, canEditRowAtIndexPath: { _, _ in
            return true
        }, canMoveRowAtIndexPath: { _, _ in
            return true
        })
        
        let movedCommand = tableView?.rx.itemMoved
            .map(TableViewEditingCommand.MoveItem)
        
        devices$
            .map{ devices in
                [SectionModel(model: "我的设备", items: devices)]
            }
            .bind(to: (tableView?.rx.items(dataSource: dataSource))!)
            .disposed(by: disposeBag)
        
        tableView?.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension DeviceListViewController: UITableViewDelegate {
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
}

struct SectionedTableViewState {
    fileprivate var sections: [SectionModel<String, Device>]
    
    init(sections: [SectionModel<String, Device>]) {
        self.sections = sections
    }
    
    func execute(command: TableViewEditingCommand) -> SectionedTableViewState {
        switch command {
        case .DeleteItem(let indexPath):
            var sections = self.sections
            var items = sections[indexPath.section].items
            items.remove(at: indexPath.row)
            sections[indexPath.section] = SectionModel(model: "我的设备", items: items)
            return SectionedTableViewState(sections: sections)
        case .MoveItem(let moveEvent):
            var sections = self.sections
            var sourceItems = sections[moveEvent.sourceIndex.section].items
            var destinationItems = sections[moveEvent.destinationIndex.section].items
            
            if moveEvent.sourceIndex.section == moveEvent.destinationIndex.section {
                destinationItems.insert(destinationItems.remove(at: moveEvent.sourceIndex.row),
                                        at: moveEvent.destinationIndex.row)
                let destinationSection = SectionModel(model: "我的设备", items: destinationItems)
                sections[moveEvent.sourceIndex.section] = destinationSection
                
                return SectionedTableViewState(sections: sections)
            } else {
                let item = sourceItems.remove(at: moveEvent.sourceIndex.row)
                destinationItems.insert(item, at: moveEvent.destinationIndex.row)
                let sourceSection = SectionModel(model: "我的设备", items: sourceItems)
                let destinationSection = SectionModel(model: "我的设备", items: destinationItems)
                sections[moveEvent.sourceIndex.section] = sourceSection
                sections[moveEvent.destinationIndex.section] = destinationSection
                
                return SectionedTableViewState(sections: sections)
            }
        }
    }
}
