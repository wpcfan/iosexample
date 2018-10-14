//
//  HomeViewModelItemType.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Foundation
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
        return "Scenes"
    }
}

class HomeViewModel: NSObject {
    var items = [HomeViewModelItem]()
    
    override init() {
        super.init()
        let result = dataFromFile("data")
        let homeInfo = HomeInfo(JSONString: result!)
        log.debug(homeInfo!)
        let bannersItem = HomeViewModelBannerItem(banners: (homeInfo?.banners)!)
        items.append(bannersItem)
        let channelsItem = HomeViewModelChannelItem(channels: (homeInfo?.channels)!)
        items.append(channelsItem)
    }
}

extension HomeViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .banners:
            if let cell = tableView.dequeueReusableCell(withIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell {
                cell.item = item
                return cell
            }
        case .channels:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier, for: indexPath) as? ChannelCell {
                cell.item = item
                return cell
            }
        case .scenes:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SceneCell.identifier, for: indexPath) as? SceneCell {
                cell.item = item
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}

extension HomeViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.frame.size.height / 4
        case 1:
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
}

public func dataFromFile(_ filename: String) -> String? {
    @objc class TestClass: NSObject { }
    let bundle = Bundle(for: TestClass.self)
    if let path = bundle.path(forResource: filename, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    }
    return nil
}
