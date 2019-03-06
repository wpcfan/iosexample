//
//  SelectDeviceViewController.swift
//  Example
//
//  Created by 王芃 on 2019/3/3.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import RxDataSources
import RxSwift
import RxCocoa

struct DeviceCapability {
    var deviceName: String?
    var feedId: String?
    var productImageUrl: String?
    var stream: JdStream
}

protocol SelectDeviceForSceneDelegate: class {
    func handleSelection(deviceCapability: DeviceCapability, type: SceneSectionType)
}

class SelectDeviceViewController: BaseViewController {
    let sdService = container.resolve(JdSmartCloudService.self)!
    weak var delegate: SelectDeviceForSceneDelegate?
    var type: SceneSectionType = .events
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, DeviceCapability>>!
    @objc weak var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = type == .events ? "selectDevice.events.title".localized : "selectDevice.actions.title".localized
        loadLayout(named: "SelectDeviceViewController.xml")
    }
}

extension SelectDeviceViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        
        weak var `self`: SelectDeviceViewController! = self
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, DeviceCapability>>(configureCell: { ds, tv, ip, item in
            let node = tv.dequeueReusableCellNode(withIdentifier: "cell")
            node?.setState([
                "streamName": item.stream.name
                ])
            return node?.view as! UITableViewCell
        })
        
        sdService.getDevicesWithSceneSupport(type: type)
            .map{ devices in
                devices.map{ (device) -> SectionModel<String, DeviceCapability> in
                    SectionModel(
                        model: device.deviceName ?? "",
                        items: device.streams?.map({ (stream) -> DeviceCapability in
                            DeviceCapability(
                                deviceName: device.deviceName,
                                feedId: device.feedId,
                                productImageUrl: device.productImageUrl,
                                stream: stream)
                        }) ?? []
                    )
                }
            }
            .debug()
            .bind(to: self.tableView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView!.rx.modelSelected(DeviceCapability.self)
            .subscribe { ev in
                guard let device = ev.element else { return }
                self.delegate?.handleSelection(deviceCapability: device, type: self.type)
            }
            .disposed(by: disposeBag)
    }
}

extension SelectDeviceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let node = tableView.dequeueReusableHeaderFooterNode(withIdentifier: "header")
        node?.setState([
            "deviceName": dataSource[section].model,
            "imageUrl": dataSource[section].items.count > 0 ? dataSource[section].items[0].productImageUrl : ""
            ])
        return node!.view as! UITableViewHeaderFooterView
    }
}
