//
//  SideBarViewController.swift
//  Example
//
import URLNavigator
import Layout
import ObjectMapper
import RxSwift
import RxDataSources

struct SideBarMenuItem: Mappable {
    var title: String?
    var icon: UIImage?
    var count: Int?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        icon <- map["icon"]
        count <- map["count"]
    }
}

class SideBarViewController: BaseViewController {
    private let CELL_REUSE_IDENTIFIER = "sidebarCell"
    private let navigator = container.resolve(NavigatorType.self)!
    let sidebarMenuService = MenuService()
    var menuItems: [SideBarMenuItem] = []
    var drawer: DrawerTransition?
    @objc weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appData = DiskUtil.getData()
        let user = appData?.user
        let house = appData?.homeInfo?.house
        self.loadLayout(named: "SideBarViewController.xml", state: [
            "avatar": user?.avatar ?? "",
            "name": "\(user?.name ?? "未设置姓名")(\(house?.isOwner ?? false ? "主账户": "子账户"))",
            "mobile": user?.mobile ?? "未设置手机号",
            "rightArrow": AppIcons.rightArrow
            ])
    }
}

extension SideBarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SideBarViewController: LayoutLoading {
    
    func layoutDidLoad(_: LayoutNode) {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SideBarMenuItem>>(configureCell: { ds, tv, ip, item in
            let node = tv.dequeueReusableCellNode(withIdentifier: "sidebarCell")
            node?.setState([
                "title": item.title ?? "",
                "icon": item.icon ?? AppIcons.placeholder,
                "count": item.count ?? -1
                ])
            return node?.view as! UITableViewCell
        })
        sidebarMenuService.request()
            .map{ menuCount in
                let items = [
                    SideBarMenuItem(JSON: ["title": "我的家人", "icon": AppIcons.family, "count": menuCount.familyCount ?? 0])!,
                    SideBarMenuItem(JSON: ["title": "我的房屋", "icon": AppIcons.home, "count": menuCount.houseCount ?? 0])!,
                    SideBarMenuItem(JSON: ["title": "我的设备", "icon": AppIcons.devices, "count": menuCount.deviceCount ?? 0])!,
                    SideBarMenuItem(JSON: ["title": "我的场景", "icon": AppIcons.scene, "count": menuCount.sceneCount ?? 0])!,
                    SideBarMenuItem(JSON: ["title": "分组管理", "icon": AppIcons.group, "count": 0])!,
                    SideBarMenuItem(JSON: ["title": "我的摄像头", "icon": AppIcons.camera, "count": -1])!,
                    SideBarMenuItem(JSON: ["title": "智能商城", "icon": AppIcons.mall, "count": -1])!,
                    SideBarMenuItem(JSON: ["title": "社区留言板", "icon": AppIcons.forum, "count": -1])!,
                    SideBarMenuItem(JSON: ["title": "帮助设置", "icon": AppIcons.settings, "count": -1])!
                ]
                return [SectionModel(model: "menu", items: items)]
            }
            .bind(to: (self.tableView.rx.items(dataSource: dataSource)))
            .disposed(by: disposeBag)
    }
}
