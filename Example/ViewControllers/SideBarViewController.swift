//
//  SideBarViewController.swift
//  Example
//
import URLNavigator
import Layout
import Disk
import ObjectMapper

struct SideBarMenuItem: Mappable {
    var title: String?
    var icon: UIImage?
    var count: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        icon <- map["icon"]
        count <- map["count"]
    }
}

class SideBarViewController: BaseViewController {
    private let CELL_REUSE_IDENTIFIER = "sidebarCell"
    private let navigator = container.resolve(NavigatorType.self)!
    var menuItems: [SideBarMenuItem] = [
        SideBarMenuItem(JSON: ["title": "我的家人", "icon": AppIcons.family, "count": 0])!,
        SideBarMenuItem(JSON: ["title": "我的房屋", "icon": AppIcons.home, "count": 0])!,
        SideBarMenuItem(JSON: ["title": "我的设备", "icon": AppIcons.devices, "count": 0])!,
        SideBarMenuItem(JSON: ["title": "我的场景", "icon": AppIcons.scene, "count": 0])!,
        SideBarMenuItem(JSON: ["title": "分组管理", "icon": AppIcons.group, "count": 0])!,
        SideBarMenuItem(JSON: ["title": "我的摄像头", "icon": AppIcons.camera, "count": -1])!,
        SideBarMenuItem(JSON: ["title": "智能商城", "icon": AppIcons.mall, "count": -1])!,
        SideBarMenuItem(JSON: ["title": "社区留言板", "icon": AppIcons.forum, "count": -1])!,
        SideBarMenuItem(JSON: ["title": "帮助设置", "icon": AppIcons.settings, "count": -1])!
    ]
    var isHouseOwner = false
    var drawer: DrawerTransition?
}

extension SideBarViewController: UITableViewDataSource {
    // Section Header Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    // rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    // dequeue cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let node = tableView.dequeueReusableCellNode(withIdentifier: "sidebarCell")
        let item = menuItems[indexPath.row]
        node?.setState([
            "title": item.title ?? "",
            "icon": item.icon ?? AppIcons.placeholder,
            "count": item.count ?? -1
            ])
        return node?.view as! UITableViewCell
    }
}

extension SideBarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SideBarViewController: LayoutLoading {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appData = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        let user = appData?.user
        self.loadLayout(named: "SideBarViewController.xml", state: [
            "avatar": user?.avatar ?? "",
            "name": "\(user?.name ?? "未设置姓名")(\(isHouseOwner ? "主账户": "子账户"))",
            "mobile": user?.mobile ?? "未设置手机号",
            "rightArrow": AppIcons.rightArrow
            ])
    }
}
