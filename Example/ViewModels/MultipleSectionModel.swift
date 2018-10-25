//
//  MultipleSectionModel.swift
//  Example
//
//  Created by 王芃 on 2018/10/22.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxDataSources

enum MultipleSectionModel {
    case banners(title: String, items: [SectionItem])
    case channels(title: String, items: [SectionItem])
    case scenes(title: String, items: [SectionItem])
}

enum SectionItem {
    case bannerItem(banners: [Banner], title: String)
    case channelItem(channels: [Banner], title: String)
    case sceneItem(scene: Scene, title: String)
}

extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch  self {
        case .banners(title: _, items: let items):
            return items.map {$0}
        case .scenes(title: _, items: let items):
            return items.map {$0}
        case .channels(title: _, items: let items):
            return items.map {$0}
        }
    }
    
    init(original: MultipleSectionModel, items: [Item]) {
        switch original {
        case let .banners(title: title, items: _):
            self = .banners(title: title, items: items)
        case let .scenes(title, _):
            self = .scenes(title: title, items: items)
        case let .channels(title, _):
            self = .channels(title: title, items: items)
        }
    }
}

extension MultipleSectionModel {
    var title: String {
        switch self {
        case .banners(title: let title, items: _):
            return title
        case .scenes(title: let title, items: _):
            return title
        case .channels(title: let title, items: _):
            return title
        }
    }
}
