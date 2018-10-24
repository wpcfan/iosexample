//
//  HomeViewModelItemType.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

enum HomeViewModelItemType {
    case banners
    case channels
    case scenes
}

protocol HomeViewModelItem {
    var type: HomeViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String?  { get }
}

extension HomeViewModelItem {
    var rowCount: Int {
        return 1
    }
}

class HomeViewModelBannerItem: HomeViewModelItem {
    var banners: Array<Banner>
    init(banners: Array<Banner>) {
        self.banners = banners
    }
    var type: HomeViewModelItemType {
        return .banners
    }
    var sectionTitle: String? {
        return nil
    }
}

class HomeViewModelChannelItem: HomeViewModelItem {
    var channels: Array<Banner>
    init(channels: Array<Banner>) {
        self.channels = channels
    }
    var type: HomeViewModelItemType {
        return .channels
    }
    var sectionTitle: String? {
        return nil
    }
}

class HomeViewModelSceneItem: HomeViewModelItem {
    var scenes: Array<Scene>
    init(scenes: Array<Scene>) {
        self.scenes = scenes
    }
    var type: HomeViewModelItemType {
        return .scenes
    }
    var sectionTitle: String? {
        return NSLocalizedString("home.table.scene.header", comment: "")
    }
    var rowCount: Int {
        return scenes.count
    }
}

class HomeViewModel: NSObject {
    var items = [HomeViewModelItem]()
    var headerImageHeight: CGFloat  = 200
    var headerToolbarHeight: CGFloat = 75
    override init() {
        super.init()
        let homeInfo = HomeInfo(
            projectId: "1", banners: [
                Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080", label: "first", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080", label: "second", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080", label: "third", link: "http://baidu.com")
            ], channels: [
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/138/138281.png", label: "first", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/148/148982.png", label: "second", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/1006/1006555.png", label: "third", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/1087/1087840.png", label: "third", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/148/148717.png", label: "third", link: "http://baidu.com")
            ], scenes: [
                Scene(id: "1", name: "go home", sceneIcon: SceneIcon.goHome, builtIn: true, order: 1, countOfDevices: 2, trigger: nil, tasks: []),
                Scene(id: "2", name: "go to school", sceneIcon: SceneIcon.goHome, builtIn: true, order: 1, countOfDevices: 3, trigger: nil, tasks: [])
            ])
        let bannersItem = HomeViewModelBannerItem(banners: (homeInfo.banners)!)
        items.append(bannersItem)
        let channelsItem = HomeViewModelChannelItem(channels: (homeInfo.channels)!)
        items.append(channelsItem)
        let scenesItem = HomeViewModelSceneItem(scenes: (homeInfo.scenes)!)
        items.append(scenesItem)
    }
}

extension HomeViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return items[section].sectionTitle
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let node = tableView.dequeueReusableHeaderFooterNode(withIdentifier: "templateHeader")
        return node?.view as? UITableViewHeaderFooterView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .banners:
            if let cell = tableView.dequeueReusableCell(withIdentifier: BannerCell.reuseIdentifier, for: indexPath) as? BannerCell {
                cell.item = item
                return cell
            }
        case .channels:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.reuseIdentifier, for: indexPath) as? ChannelCell {
                cell.item = item
                return cell
            }
        case .scenes:
            if let item = item as? HomeViewModelSceneItem {
                let node = tableView.dequeueReusableCellNode(withIdentifier: "SceneCell", for: indexPath)
                let scene = item.scenes[indexPath.row]
                node.setState([
                    "title": scene.name!,
                    "icon": scene.sceneIcon
                    ])
                
                return node.view as! UITableViewCell
            }
        }
        return UITableViewCell()
    }
}

extension HomeViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
        switch item.type {
        case .banners:
            return tableView.frame.size.height / 4
        case .channels:
            return 88
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0, 1:
            return CGFloat.leastNonzeroMagnitude
        default:
            return UITableView.automaticDimension
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        let y = -scrollView.contentOffset.y
        let height = min(max(y, 60), 400)
        print("y", y)
        headerImageHeight = height
    }
}


public func dataFromFile(_ filename: String) -> String? {
    @objc class TestClass: NSObject { }
    let bundle = Bundle(for: TestClass.self)
    if let path = bundle.path(forResource: filename, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    }
    return nil
}
